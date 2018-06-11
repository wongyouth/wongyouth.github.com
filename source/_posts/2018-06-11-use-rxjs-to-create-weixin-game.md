---
title: 用 rxjs 改写微信官方小游戏
date: 2018-06-11 15:58:11
tags: ['微信', 'rxjs', '游戏']
---

自从去年2017年微信开放了小游戏之后，极大的促进H5游戏的发展。可以想象今年微信游戏必定非常火。
乘着这股春风，结合近期研究的 `rxjs`，想尝试下用 `rxjs` 改写微信官方小游戏。

![wexin-game](/images/blog/weixin-game.png)

<!-- more -->

`rxjs` 是响应式编程的 Javascript 库。

响应式的概念就是声明式编程的方法，代表的有 React， Vue。 在我理解他与传统的命令式编程方法最大的区别在于： 不是根据事件来处理每个逻辑，而是先设置好每个事件的 flow，只要有一个事件触发了，那么这些事件会带动触发其他事件，再接着触发其他事件，最后汇集到一个状态量中。而 View 上的更新是只更根据状态做显示。

除了现在流行的使用类来组织代码，还有一种完全不同的代码组织方式，那就是函数式编程。
这可能是另外一个话题，但是有趣的是使用 `rxjs` 你可以完全只使用函数来写代码。

不再啰嗦，看代码。


### 游戏包括

- 地图的滚动更新
- 飞机的位置
- 敌机群的位置
- 子弹的位置
- 爆炸动画的位置，与当前播放的图片索引值
- 游戏是否结束
- 分数

### 整体的代码结构与状态流

    const clock$ = interval(1000 / FPS, animationFrameScheduler)
    const playerSubject$ = new BehaviorSubject()

    const bg$ = {...}
    const player$ = {...}
    const enemies$ = {...}
    const bullets$ = {...}
    const explosions$ = {...}
    const collision$ = {...}
    const restart$ = {...}

    const state$ = merge(bg$, player$, enemies$, bullets$, collision$, explosions$, restart$)
      .pipe(
        startWith(getInitState()),
        scan((state, reducer) => reducer(state))
      )

    bgmAudio.play()
    state$.subscribe(function(state) {
      playerSubject$.next(state.player)
      render(state)
    })


状态流是由上面提到的背景，敌机，飞机，子弹等流合成，在 `subscribe` 的回调函数里面，只要根据最新的 `state` 画图就可以了。

### 初始状态

    function getInitState() {
      return {
        bg: {
          img: bgImg,
          width: BG_WIDTH,
          height: BG_HEIGHT,
          top: 0
        },
        player: {
          img: playerImg,
          width: PLAYER_WIDTH,
          height: PLAYER_HEIGHT,
          x: screenWidth / 2 - PLAYER_WIDTH / 2,
          y: screenHeight - PLAYER_HEIGHT - 30
        },
        enemies: [],
        bullets: [],
        explosions: {
          images: aniImgs,
          frames: []
        },
        gameover: false,
        score: 0
      }
    }


与传统的类不太一样，现在前端开发中特别是单页应用中越来越用到一个概念就是要有一个全局的状态来管理共享数据，来起到所有组件内同步更新的作用。这里也沿用了这种方式，特别是在调试的时候可以很方便的查看游戏内部的状态。

下面我们再来细看每个流：


### 时钟流

每秒60帧，每个时钟单位约16.67毫秒，这是大部分游戏的设置值。帧率越大画面越流畅。

    const clock$ = interval(1000 / FPS, animationFrameScheduler)
      .pipe(share())

这里用到一个 `share()`，是因为这个时钟流会多次用到，所以做了共享。

### 地图背景流

地图背景的更新，每个时钟单位 top 值增加 2 个像素值

    const bg$ = clock$
      .pipe(
        map(() => state => {
          if (state.gameover) return state

          state.bg.top = state.bg.top > screenHeight ? 0 : state.bg.top + 2
          return state
        })
      )

### 飞机流

飞机位置的移动要响应触屏移动，而触屏时需要根据飞机当前值来确定要不要触发移动，所以需要当前的状态，而状态又是由飞机流来生成的，是一个循环。如果碰到这种循环的情况要用到 Subject 来解决， Subject 相当于一个中介的概念。内部是一个 `pub` `sub` 模式。

    const playerSubject$ = new BehaviorSubject()

    const touchstart$ = fromEvent(canvas, 'touchstart').pipe(share())
    const touchend$ = fromEvent(canvas, 'touchend')
    const touchmove$ = fromEvent(canvas, 'touchmove')

飞机的移动只在触屏时触发，所以由 touchstart$ 作为发起源，当手指在飞机的触屏移动是， playerMove$ 就会发出当前的位置

    const playerMove$ = touchstart$.pipe(
      withLatestFrom(playerSubject$),
      filter(([ev, player]) => {
        return checkIsFingerOnAir(ev, player)
      }),
      mergeMap(() => {
        return touchmove$.pipe(takeUntil(touchend$))
      }),
      map(ev => ev.touches[0]),
      // tap(console.log),
    )

player$ 根据触屏的位置来改变飞机的位置

    const player$ = playerMove$
      .pipe(
        map(({clientX, clientY}) => (state) => {
          if (state.gameover) return state

          const {player} = state
          player.x = range(clientX - player.width / 2, 0, screenWidth - player.width)
          player.y = range(clientY - player.height / 2, 0, screenHeight - player.height)

          return state
        })
      )


### 子弹流

子弹流比较简单，每个 clock 单位改变已有子弹的y值，但超出屏幕时从列表内删除，每 20 个 clock 单位产生新的子弹。


    const bullets$ = clock$.pipe(
      map(frame => state => {
        if (state.gameover) return state

        const player = state.player

        // 移动子弹
        state.bullets.forEach(function(bullet, index) {
          bullet.y -= 6
          if (bullet.y < -BULLET_HEIGHT) {
            state.bullets.splice(index, 1)
          }
        })

        // 动态生成
        if (frame % 20 === 0) {
          state.bullets.push({
            img: bulletImg,
            x: player.x + player.width / 2 - BULLET_WIDTH / 2,
            y: player.y - BULLET_HEIGHT,
            width: BULLET_WIDTH,
            height: BULLET_HEIGHT
          })

          bulletAudio.play()
        }
        return state
      })
    )

### 爆炸流

爆炸动画的流，由新产生的爆炸流，和改变显示的图片来完成。爆炸由碰撞检测产生，这里用了 explosionSubject$ 来做中转。当所有的爆炸图片显示完时，从列表移除，不再显示。

    const explosionSubject$ = new Subject()
    const newExplo$ = explosionSubject$.pipe(
      map(enemy => state => {
        const frame = Object.assign({}, enemy, {index: 0})
        state.explosions.frames.push(frame)

        return state
      })
    )
    const exploPlay$ = clock$.pipe(
      map(() => state => {
        for (const frame of state.explosions.frames) {
          frame.index += 1
          frame.y += 6
        }

        state.explosions.frames = state.explosions.frames.filter(frame => frame.index < state.explosions.images.length)

        return state
      })
    )

    const explosions$ = merge(exploPlay$, newExplo$)

### 敌机流

敌机流也比较简单，每 30 个 clock 单位新产生一个敌机，每个 clock 单位移动

    const enemies$ = merge(clock$)
      .pipe(
        map(frame => state => {
          if (state.gameover) return state

          // 移动敌机
          state.enemies.forEach(function(enemy, index) {
            enemy.y += 6
            if ( enemy.y > screenHeight + enemy.height) {
              state.enemies.splice(index, 1)
            }
          })

          // 生成
          if (frame % 30 === 0) {
            state.enemies.push({
              img: enemyImg,
              x: rnd(0, screenWidth - ENEMY_WIDTH),
              y: -ENEMY_HEIGHT,
              width: ENEMY_WIDTH,
              height: ENEMY_HEIGHT,
              speed: 6
            })
          }

          return state
        })
      )



### 碰撞流

碰撞流做了两个检测，一个检测子弹是否击中敌机，如果击中，则 explosionSubject$.next(enemy) 下，让爆炸显示。另一个则是检测敌机与我方飞机的碰撞检测，如果击中，则游戏结束。


    const collision$ = clock$.pipe(
      map(() => state => {
        if (state.gameover) return state

        state.bulltes = state.bullets.filter(bullet => {
          state.enemies.every((enemy, index) => {
            if (isCollideWith(enemy, bullet)) {
              state.enemies.splice(index, 1)
              boomAudio.play()
              state.score += 1
              explosionSubject$.next(enemy)
              return false
            }

            return true
          })
        })

        for (const enemy of state.enemies) {
          if (isCollideWith(state.player, enemy)) {
            state.gameover = true
            break
          }
        }
        return state
      })
    )

### 重启流

重新游戏流，检测是否在游戏终止时，点击了重新游戏这个按钮，是则重置游戏状态，开始新游戏



    const restart$ = touchstart$.pipe(
      filter(ev => {
        const {clientX, clientY} = ev.touches[0]

        return (
          clientX > btnArea.startX
          && clientX < btnArea.endX
          && clientY > btnArea.startY
          && clientY < btnArea.endY
        )
      }),
      map(() => state => state.gameover ? getInitState() : state)
    )


### 状态流

所有以上的流 merge 之后通过 reducer 来完成每次状态的更新。我们这里所有的流发出的不是一般的数据，而是函数，所以当接收到函数时，我们把当前 `state` 传入这个函数中去，更新状态里相应的数据，返回新的状态。而状态流放出的则是当前的最新状态值。

    const state$ = merge(bg$, player$, enemies$, bullets$, collision$, explosions$, restart$)
      .pipe(
        startWith(getInitState()),
        scan((state, reducer) => reducer(state))
      )

订阅这个 state$ 状态流，每时钟单位根据状态值画图。
其中

    playerSubject$.next(state.player)

这行代码是通知之前的 playerSubject$ 来中转更新飞机位置

    bgmAudio.play()
    state$.subscribe(function(state) {
      playerSubject$.next(state.player)
      render(state)
    })


结论
====

游戏在我的小米Note3手机的微信测试了下，帧率一般在56 ~ 60 左右，可以看到，使用 `rxjs` 是可以写游戏代码的。

代码通过 `webpack` 打包后，832k ，有点大，但是离微信的上限4M还是很大空余空间的。

`rxjs` 可以改变代码的编写方式，甚至思维方式。数据在各个流之间进行流动，最后汇集到一个状态内，我们只要管理状态到视图的更新显示，感觉整体的结构还是很直观的。

与原来的代码比较，原来的代码游戏在 `Game over` 时有bug，手指还是可以拖动飞机的移动， `rxjs` 版不会有这个问题。

感觉 `rxjs` 的潜力还没有被挖掘出来，可能在处理多人联机游戏的 `rxjs` 带来的好处将更大。

本篇例子中完全舍去了类的使用，只使用到了函数。但是重点不在这里，完全可以使用类结合 `rxjs` 来使用，毕竟 `es6` 支持了类，当然要发挥它的长处。

后奉上[源码](https://github.com/wongyouth/rxjs-wxgame)。


参考
====

[Rxjs](https://reactivex.io/)
[Learning rxjs](https://www.learnrxjs.io/)
[Game State with RxJS 5/Immutable.js](https://manu.ninja/game-state-with-rxjs-5-immutable-js)

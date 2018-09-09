---
title: 说说小程序美团框架mpvue
date: 2018-09-07 22:49:48
tags: ['Vue', '小程序']
---

这段时间开始做小程序的开发，所以稍微研究了下小程序的开发框架。
当下比较有名的有以下几个开发框架:

* 基于模板的类 vue 的原生框架
* 在原生框架上改良的仿 `Vue` 框架 `wepy`
* 基于 `Vue` 的 `mpvue`
* 基于 `React` 的 `taro`。

另外还有几个小众的：

* [anu](https://github.com/RubyLouvre/anu)
* [tina](https://tina.js.org/)

因为之前比较熟悉`Vue`，所以没有太费脑力就选了 `mpvue`。

看了文档觉得虽然有所限制，比如：

* 模板里不能写复制的表达式
* 模板里不能用函数
* 不能用 filter
* 不能用 slot

感觉虽然有限制，但是好像没有特别大的关系。多费点代码还是能克服的。

谁知道，刚码了两个页面就遇到了坑。

* beforeDestroy 回调基本没用
* mounted 可能永远不会调用第二次
* 再次进入页面时有上次状态的残影
* 再次进入页面时取不到变化的页面路径参数
* 使用 HTML 原有的标签名作为组件名时，自定义组件内模板不起作用
* 错误如果不捕捉会被吞没，不报错

倒不是某个框架的问题，搜了一下其他的框架基本也都有这些问题。

还没有具体看过 `mpvue` 源码，但是看了前人介绍，有些是因为小程序的特色所导致的。
比如为什么页面再次打开会有之前的状态值存留。

个人感觉以下内部世界被割裂成了3个世界：

mpvue 对象 -> 小程序Page对象 -> View render

原生的 Page 里 通过 `setData` 把数据传输给视图进行显示，
当页面关闭后，页面对象消失，但是 `mpvue` 对象会重复使用，
每次页面重开时会使用之前的 mpvue 对象，造成了数据的残留。
理想状态是 Page 关闭时，销毁 mpvue 对象，打开时再重新生成。这样整个生命周期就与预期一致了。

正因为以上的原因，造成了很多意想不到的问题(keng)。

也探索了一些解决方法：

问题1：数据残留

    export default {
      data () {
        return {
          a: 23
        }
      }
    }

对策：onUnload里重置初始值

    export default {
      data () {
        return {
          a: 23
        }
      },

      onUnload () {
        Object.assign(this.$data, this.$options.data())
      }
    }

这里的 `this.$options` 是`Vue`内部使用的属性，保留着初始的对象值。
可以把他写成一个Vue plugin，这样就可以省却每个页面都要写的尴尬。


问题2：computed 内获取的参数不会变化


    export default {
      computed: {
        id () {
          return this.$root.$mp.query.id
        }
      }
    }

对策：写入 mounted 里，赋值到 `data` 对象内

    export default {
      data () {
        return {
          id: null
        }
      },

      mounted () {
        this.id = this.$root.$mp.query.id
      }
    }

问题: 组件文件名不要使用HTML标签名

组件名用了 article， 引入时不报错，但是组件内部模板不显示，也不报错。
即使引入时改了，也还是不显示：

    import Article2 from './article'

对策: 为了减少麻烦，一定要使用非HTML标签名，引入时也最好名称一致。

问题4：自定义组件时写的事件处理函数不起作用

    <template lang='pug'>
      .container
        tag1(
          @click='handler'
          v-for='item in items'
          :key='item.id'
        )
    </template>

对策：如果想再调用时处理事件的话，需要在自定义内部通过`$emit` 发出来，
自定义组件所有的事件都需要自己发射到父组件。

暂时就先记这么多，后续有再跟进。
多说一句： `mpvue` 是基于 `Vue` 2.4.1 基础上开发的，所有 2.4.1 以上的功能就不要去用了。

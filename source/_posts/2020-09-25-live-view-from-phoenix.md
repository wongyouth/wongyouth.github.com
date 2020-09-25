---
title: Live View from Phoenix
date: 2020-09-25 17:26:29
tags: ['Rails', 'Elixir', 'Phoenix', 'Live View']
---

# Beyond Rails

-- Elixir and Phoenix Framework

First try of Live View from Phoenix

<!-- more -->

---

## Language History

First released Published

- Ruby - 1995, same year of java
- Rails - 2004

- Elixir - 2011
- Phoenix - 2014

- Erlang - 1986

---

## Why Elixir

- Lightweight concurrency based on Erlang VM (over 30 years)
- Thread safe (by no thread at all)
- Simple, just function
- Balance of productivity and performance
- Pattern matching
- Immutability

---

## Create Phoenix project

show all mix command

    mix help

install hex - a package manager

    mix local.hex

install phx_new package

    mix archive.install hex phx_new

create a phoenix project

    mix phx.new hxdemo


---

## Live view

- Learned from Frontend
- Use backend as a state store
- but don't need API.
- You don't have to write a single line of Javascript.

---

## What you need to do

basically 3 methods is used

- mount
- render
- handle_event

---

## mount methods

    def mount(_params, _session, socket) do
      {:ok, assign(socket, counter: 0)}
    end

---

## render methods

    def render(assigns) do
      ~L"""
      Counter <% @counter %>
      <button phx-click="inc">+</button>
      """
    end

---

## render methods

    def handle_event("inc", _params, socket) do
      {:noreply, assign(socket, count: socket.assigns.count + 1)}
    end

---

## Internal

- Use websocket (use long pull as fallback)
- Frontend phoenix liveview javascript
- One connection with one GenServer at backend

---

# the End


# Wednesday 23 July 2025

## Web Components

I was working on [lutenant](https://github.com/joshkgarber/lutenant) and I realized that up until now, when working with web components I never used the shadow root and it was about time I tried it out. I was curious about the use case for shadow root. Why would you want to isolate your HTML code from the rest of the DOM? After reading the [docs on MDN](https://developer.mozilla.org/en-US/docs/Web/API/Web_components/Using_shadow_DOM) I realized that this _is_ a good idea for custom web components because you can encapsulate your content and styling in it's own little box, without worrying about effects from the outside. So I experimented with this and learned how to attach a shadow with its own styles and content. It was exciting to see everything defined in one place. My own little component that could be dropped in anywhere and look the same no matter what.

```js
class LutHello extends HTMLElement {
    constructor() {
        super();    
    }
    connectedCallback() {
        const styles = new CSSStyleSheet();
        styles.replaceSync("span { font-weight: 800 }")
        const shadow = this.attachShadow({ mode: "open" });
        shadow.adoptedStyleSheets = [styles];
        const text = this.getAttribute("data-text");
        const span = document.createElement("span");
        span.textContent = text;
        shadow.appendChild(span);
    }
}
customElements.define("lut-hello", LutHello);
```

Structure, style, and behavior, all in **one place**. This makes me happy.

One thing that caught me off-guard though, if you add an external stylesheet and add to it a rule which targets the component itself, it does affect the style. For example:

```css
lut-hello {
    color: white;
}
```

That will turn the text within in `&lt;lut-hello>` tag white. I'm interested to know how best to manage this situation. Perhaps you can remove the external stylesheet from the list of stylesheets related to the component.

## Fixed a Bug

The program I use to build and maintain this blog is a static site generator. It's actually written from scratch by me with guidance from [boot.dev](https://www.boot.dev/courses/build-static-site-generator-python). Yesterday, I found a bug which caused issues in the way markdown syntax for links was being parsed into `&lt;a>` tags. Every bug is an opportunity to prove and/or improve yourself. This particular one taught me just a little bit more about regular expressions, and I enjoy that part of the development experience. When you get down to the nitty gritty of a task, and you end up at the point where you just have to solve a problem in your own head, that's a moment of creativity that I love, and the reason I love to code.

```
pattern = r"(?&lt;!!)\[([^\[\]]*)\]\(([^\[\]\(\)]*)\)"
```

(See [inline_markdown.py](https://github.com/joshkgarber/blog/blob/main/src/inline_markdown.py).)

## Command-line Speed Test

Yesterday I set up a command-line program to test internet speed: [speedtest-cli](https://github.com/sivel/speedtest-cli).

This is how I installed it:

```bash
wget -O ~/Downloads/speedtest-cli https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py
sudo chmod +x ~/Downloads/speedtest-cli
mv ~/Downloads/speedtest-cli ~/.local/bin/
```

You can run it with the command `speedtest-cli`.

I ran into an issue with this. From what I understand, the script was trying to run `python` and couldn't find a matching python binary. I researched the issue and checked my env variable with `echo $(env)`. I know that the `python` command never works unless I'm in a venv, but `python3` does work. So I updated the shebang to `#!usr/bin/env python3`. It worked!

I'm interested to see if there's a way to update the system so that `python` would default to `python3`, but there are also things about this which I need to clarify for my own understanding as a Linux user: what is `env`? How do I maintain my `PATH` correctly? How can I make sure that the right Python version is installed on a new machine the way I want it? In the future, I would prefer not to have to manually edit the shebang when I know the right binary is in my `PATH`.

This touches on a different topic of my personal setup on Ubuntu, which I haven't been documenting. Sometimes I think about restarting from scratch and documenting everything properly. That way I can keep things clean and under control. I think this will be something that I keep improving as time goes on.

## .vimrc

I'm a Vim user and as a beginner I'm still new to the world of vim config. Today I learned that it's a world full of possibilities and the best way to get started is to use plugins. So I learned about and started getting more into using [lightline](https://github.com/itchyny/lightline.vim).

I also learned about **paste mode** which allows you to paste from the clipboard without that ruptuous indentation effect you otherwise get without it! You can set paste mode on and off with the following commands:

```vimscript
:set paste
:set nopaste
```

## Lit

I was checking out some custom components I found in the YouTube.com source code, and it led me to [Lit](https://github.com/lit/lit/). It's really exciting to see custom components are being used by all sorts of projects out there. I would love to specialize in this topic. It looks like it could be a valuable area of expertise.


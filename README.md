# twitter-vim

![Displaying Cher's tweets in vim.](https://raw.githubusercontent.com/vmchale/clit-rs/master/vim-twitter-screenshot.png)

## Installation

For `vim-plug`, add the following to your `~/.vimrc`:

```
Plug 'vmchale/twitter-vim'
```

You'll have to install the Haskell **C**ommand **L**ine **I**nterface
**T**weeter, viz.

```
stack install clit
```

You can also download it for linux from [here](https://github.com/vmchale/command-line-tweeter/releases);
hopefully it shouldn't be too hard to find. 

There is also a rust version that is mostly complete, available
[here](https://github.com/vmchale/command-line-tweeter/releases).

## Config
After that, put your API keys in a file (default `~/.cred` or set path with 
`g:twitter_cred`), viz.

```
api-key: API_KEY_HERE
api-sec: API_SECRET_HERE
tok: OAUTH_TOKEN_HERE
tok-sec: TOKEN_SECRET_HERE
```

If you want to use the rust backend instead of the haskell backend, put the
following in your `.vimrc`:

```vim
let g:twitter_use_rust=1
```

## Use

To view your timeline, use `:Timeline` or `<silent> tl`. To tweet, enter
`:Tweet` to open a scratch buffer, and then `t` in normal mode to tweet its
contents. Hit `q` to exit. 

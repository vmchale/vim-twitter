# twitter-vim

## Installation

You'll have to install the Haskell __C__ommand __L__ine __I__nterface
__T__weeter, viz.

```
stack install clit
```

You can also download it from [here](https://github.com/vmchale/command-line-tweeter); 
hopefully it shouldn't be too hard to find. 

## Config
After tha, put your API keys in a file (default `~/.cred` or set path with 
`g:twitter_cred`), viz.

```
api-key: API_KEY_HERE
api-sec: API_SECRET_HERE
tok: OAUTH_TOKEN_HERE
tok-sec: TOKEN_SECRET_HERE
```

## Use

To view your timeline, use `:Timeline` or `<silent> tt`. To tweet, enter
`:Tweet` to open a scratch buffer, and then `t` in normal mode to tweet its
contents. Hit `q` to exit. 

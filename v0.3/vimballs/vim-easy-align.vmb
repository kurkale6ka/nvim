" Vimball Archiver by Charles E. Campbell
UseVimball
finish
./.gitattributes	[[[1
7
.travis.yml    export-ignore
.gitattributes export-ignore
.gitignore     export-ignore
doc/tags       export-ignore
*.md           export-ignore
zip            export-ignore
test/*         export-ignore
./.gitignore	[[[1
2
doc/tags
*.zip
./.travis.yml	[[[1
15
language: vim

before_script: |
  git clone https://github.com/junegunn/vader.vim.git
  git clone https://github.com/tpope/vim-repeat

script: |
  vim -Nu <(cat << VIMRC
  filetype off
  set rtp+=vader.vim
  set rtp+=vim-repeat
  set rtp+=.
  filetype plugin indent on
  syntax enable
  VIMRC) -c 'Vader! test/*' > /dev/null
./EXAMPLES.md	[[[1
416
easy-align examples
===================

Open this document in your Vim and try it yourself.

This document assumes that you have the following mappings in your .vimrc.

```vim
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
```

You can use either of the maps. Place the cursor on the paragraph and press

- `gaip` "(ga) start easy-align on (i)nner (p)aragraph"
- or `vipga` "(v)isual-select (i)nner (p)aragraph and (ga) start easy-align"

To enable syntax highlighting in the code blocks, define and call the following
function.

```vim
function! GFM()
  let langs = ['ruby', 'yaml', 'vim', 'c']

  for lang in langs
    unlet b:current_syntax
    silent! exec printf("syntax include @%s syntax/%s.vim", lang, lang)
    exec printf("syntax region %sSnip matchgroup=Snip start='```%s' end='```' contains=@%s",
                \ lang, lang, lang)
  endfor
  let b:current_syntax='mkd'

  syntax sync fromstart
endfunction
```

Alignment around whitespaces
----------------------------

You can align text around whitespaces with `<space>` delimiter key.

Start the interactive mode as described above (`gaip` or `vipga`) and try
these commands:

- `<space>`
- `2<space>`
- `*<space>`
- `-<space>`
- `-2<space>`
- `<Enter><space>`
- `<Enter>*<space>`
- `<Enter><Enter>*<space>`

### Example

```

Paul McCartney 1942
George Harrison 1943
Ringo Starr 1940
Pete Best 1941

```

Formatting table
----------------

Again, start the interactive mode and try these commands:

- `*|`
- `**|`
- `<Enter>*|`
- `<Enter>**|`
- `<Enter><Enter>*|`

### Example

```

| Option| Type | Default | Description |
|--|--|--|--|
| threads | Fixnum | 1 | number of threads in the thread pool |
|queues |Fixnum | 1 | number of concurrent queues |
|queue_size | Fixnum | 1000 | size of each queue |
|   interval | Numeric | 0 | dispatcher interval for batch processing |
|batch | Boolean | false | enables batch processing mode |
 |batch_size | Fixnum | nil | number of maximum items to be assigned at once |
 |logger | Logger | nil | logger instance for debug logs |

```


Alignment around =
------------------

The default rule for delimiter key `=` aligns around a whole family of
operators containing `=` character.

Try these commands in the interactive mode.

- `=`
- `*=`
- `**=`
- `<Enter>**=`
- `<Enter><Enter>*=`

### Example

```ruby

a =
a = 1
bbbb = 2
ccccccc = 3
ccccccccccccccc
ddd = 4
eeee === eee = eee = eee=f
fff = ggg += gg &&= gg
g != hhhhhhhh == 888
i   := 5
i     %= 5
i       *= 5
j     =~ 5
j   >= 5
aa      =>         123
aa <<= 123
aa        >>= 123
bbb               => 123
c     => 1233123
d   =>      123
dddddd &&= 123
dddddd ||= 123
dddddd /= 123
gg <=> ee

```

Formatting YAML (or JSON)
-------------------------

You can use `:`-rule here to align text around only the first occurrences of
colons. In this case, you don't want to align around all the colons: `*:`.

```yaml
mysql:
  # JDBC driver for MySQL database:
  driver: com.mysql.jdbc.Driver
  # JDBC URL for the connection (jdbc:mysql://HOSTNAME/DATABASE)
  url: jdbc:mysql://localhost/test
  database: test
  "user:pass":r00t:pa55
```

Formatting multi-line method chaining
-------------------------------------

Try `.` or `*.` on the following lines.

```ruby
my_object
      .method1().chain()
    .second_method().call()
      .third().call()
     .method_4().execute()
```

Notice that the indentation is adjusted to match the shortest one among those of
the lines starting with the delimiter.

```ruby
my_object
    .method1()      .chain()
    .second_method().call()
    .third()        .call()
    .method_4()     .execute()
```


Using blockwise-visual mode or negative N-th parameter
------------------------------------------------------

You can try either:
- select text around `=>` in blockwise-visual mode (`CTRL-V`) and `ga=`
- or `gaip-=`

```ruby
options = { :caching => nil,
            :versions => 3,
            "cache=blocks" => false }.merge(options)
```

Commas
------

There is also a predefined rule for commas, try `*,`.

```
aaa,   bb,c
d,eeeeeee
fffff, gggggggggg,
h, ,           ii
j,,k
```

Ignoring delimiters in comments or strings
------------------------------------------

Delimiters highlighted as comments or strings are ignored by default, try
`gaip*=` on the following lines.

```c

/* a */ b = c
aa >= bb
// aaa = bbb = cccc
/* aaaa = */ bbbb   === cccc   " = dddd = " = eeee
aaaaa /* bbbbb */      == ccccc /* != eeeee = */ === fffff

```

This only works when syntax highlighting is enabled.

Aligning in-line comments
-------------------------

*Note: Since the current version provides '#'-rule as one of the default rules,
you can ignore this section.*

```ruby
apple = 1 # comment not aligned
banana = 'Gros Michel' # comment 2
```

So, how do we align the trailing comments in the above lines? Simply try
`-<space>`. The spaces in the comments are ignored, so the trailing comment in
each line is considered to be a single chunk.

But that doesn't work in the following case.

```ruby
apple = 1 # comment not aligned
apricot = 'DAD' + 'F#AD'
banana = 'Gros Michel' # comment 2
```

That is because the second line doesn't have trailing comment, and
the last (`-`) space for that line is the one just before `'F#AD'`.

So, let's define a custom mapping for `#`.

```vim
if !exists('g:easy_align_delimiters')
  let g:easy_align_delimiters = {}
endif
let g:easy_align_delimiters['#'] = { 'pattern': '#', 'ignore_groups': ['String'] }
```

Notice that the rule overrides `ignore_groups` attribute in order *not to ignore*
delimiters highlighted as comments.

Then on `#`, we get

```ruby
apple = 1         # comment not aligned
apricot = 'DAD' + 'F#AD'
banana = 'string' # comment 2
```

If you don't want to define the rule, you can do the same with the following
command:

```vim
" Using regular expression /#/
" - "ig" is a shorthand notation of "ignore_groups"
:EasyAlign/#/{'ig':['String']}

" Or more concisely with the shorthand notation;
:EasyAlign/#/ig['String']
```

In this case, the second line is ignored as it doesn't contain a `#` (The one
in `'F#AD'` is ignored as it's highlighted as String). If you don't want the
second line to be ignored, there are three options:

1. Set global `g:easy_align_ignore_unmatched` flag to 0
2. Use `:EasyAlign` command with `ignore_unmatched` option
3. Update the alignment rule with `ignore_unmatched` option

```vim
" 1. Set global g:easy_align_ignore_unmatched to zero
let g:easy_align_ignore_unmatched = 0

" 2. Using :EasyAlign command with ignore_unmatched option
" 2-1. Using predefined rule with delimiter key #
"      - "iu" is expanded to "*i*gnore_*u*nmatched"
:EasyAlign#{'iu':0}
" or
:EasyAlign#iu0

" 2-2. Using regular expression /#/
:EasyAlign/#/ig['String']iu0

" 3. Update the alignment rule with ignore_unmatched option
let g:easy_align_delimiters['#'] = {
  \ 'pattern': '#', 'ignore_groups': ['String'], 'ignore_unmatched': 0 }
```

Then we get,

```ruby
apple = 1                # comment not aligned
apricot = 'DAD' + 'F#AD'
banana = 'string'        # comment 2
```

Aligning C-style variable definition
------------------------------------

Take the following example:

```c
const char* str = "Hello";
int64_t count = 1 + 2;
static double pi = 3.14;
```

We can align these lines with the predefined `=` rule. Select the lines and
press `ga=`

```c
const char* str  = "Hello";
int64_t count    = 1 + 2;
static double pi = 3.14;
```

Not bad. However, the names of the variables, `str`, `count`, and `pi` are not
aligned with each other. Can we do better? We can clearly see that simple
`<space>`-rule won't properly align those names.
So let's define an alignment rule than can handle this case.

```vim
let g:easy_align_delimiters['d'] = {
\ 'pattern': '\(const\|static\)\@<! ',
\ 'left_margin': 0, 'right_margin': 0
\ }
```

This new rule aligns text around spaces that are *not* preceded by
`const` or `static`. Let's select the lines and try `gad`.

```c
const char*   str = "Hello";
int64_t       count = 1 + 2;
static double pi = 3.14;
```

Okay, the names are now aligned. We select the lines again with `gv`, and then
press `ga=` to finish our alignment.

```c
const char*   str   = "Hello";
int64_t       count = 1 + 2;
static double pi    = 3.14;
```

So far, so good. However, this rule is not sufficient to handle more complex
cases involving C++ templates or Java generics. Take the following example:

```c
const char* str = "Hello";
int64_t count = 1 + 2;
static double pi = 3.14;
static std::map<std::string, float>*    scores = pointer;
```

We see that our rule above doesn't work anymore.

```c
const char*                  str = "Hello";
int64_t                      count = 1 + 2;
static double                pi = 3.14;
static std::map<std::string, float>*    scores = pointer;
```

So what do we do? Let's try to improve our alignment rule.

```vim
let g:easy_align_delimiters['d'] = {
\ 'pattern': ' \ze\S\+\s*[;=]',
\ 'left_margin': 0, 'right_margin': 0
\ }
```

Now the new rule has changed to align text around spaces that are followed
by some non-whitespace characters and then an equals sign or a semi-colon.
Try `vipgad`

```c
const char*                          str = "Hello";
int64_t                              count = 1 + 2;
static double                        pi = 3.14;
static std::map<std::string, float>* scores = pointer;
```

We're right on track, now press `gvga=` and voila!

```c
const char*                          str    = "Hello";
int64_t                              count  = 1 + 2;
static double                        pi     = 3.14;
static std::map<std::string, float>* scores = pointer;
```

./README.md	[[[1
763
vim-easy-align ![travis-ci](https://travis-ci.org/junegunn/vim-easy-align.svg?branch=master)
==============

A simple, easy-to-use Vim alignment plugin.

![](https://raw.githubusercontent.com/junegunn/i/master/easy-align/equals.gif)

Installation
------------

Use your favorite plugin manager.

Using [vim-plug](https://github.com/junegunn/vim-plug):

```vim
Plug 'junegunn/vim-easy-align'
```

Quick start guide
-----------------

Add the following mappings to your .vimrc.

```vim
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
```

Then with the following lines of text,

```
apple   =red
grass+=green
sky-=   blue
```

try these commands:

- `vipga=`
    - `v`isual-select `i`nner `p`aragraph
    - Start EasyAlign command (`ga`)
    - Align around `=`
- `gaip=`
    - Start EasyAlign command (`ga`) for `i`nner `p`aragraph
    - Align around `=`

Demo
----

*Click on each image to see from the beginning.*

### Using predefined alignment rules

An *alignment rule* is a predefined set of options for common alignment tasks,
which is identified by a single character, such as `<Space>`, `=`, `:`, `.`,
`|`, `&`, `#`, and `,`.

#### `=`

![](https://raw.githubusercontent.com/junegunn/i/master/easy-align/equals.gif)

- `=` Around the 1st occurrences
- `2=` Around the 2nd occurrences
- `*=` Around all occurrences
- `**=` Left/Right alternating alignment around all occurrences
- `<Enter>` Switching between left/right/center alignment modes

#### `<Space>`

![](https://raw.githubusercontent.com/junegunn/i/master/easy-align/spaces.gif)

- `<Space>` Around the 1st occurrences of whitespaces
- `2<Space>` Around the 2nd occurrences
- `-<Space>` Around the last occurrences
- `<Enter><Enter>2<Space>` Center-alignment around the 2nd occurrences

#### `,`

![](https://raw.githubusercontent.com/junegunn/i/master/easy-align/commas.gif)

- The predefined comma-rule places a comma right next to the preceding token
  without margin (`{'stick_to_left': 1, 'left_margin': 0}`)
- You can change it with `<Right>` arrow

### Using regular expression

![](https://raw.githubusercontent.com/junegunn/i/master/easy-align/regex.gif)

You can use an arbitrary regular expression by
- pressing `<Ctrl-X>` in interactive mode
- or using `:EasyAlign /REGEX/` command in visual mode or in normal mode with
  a range (e.g. `:%`)

### Different ways to start

![](https://raw.githubusercontent.com/junegunn/i/master/easy-align/modes.gif)

This demo shows how you can start interactive mode with visual selection or use
non-interactive `:EasyAlign` command.

### Aligning table cells

![](https://raw.githubusercontent.com/junegunn/i/master/easy-align/tables.gif)

Check out various alignment options and "live interactive mode".

### Syntax-aware alignment

![](https://raw.githubusercontent.com/junegunn/i/master/easy-align/yaml.gif)

Delimiters in strings and comments are ignored by default.

### Using blockwise-visual mode

![](https://raw.githubusercontent.com/junegunn/i/master/easy-align/blockwise-visual.gif)

You can limit the scope with blockwise-visual mode.

Usage
-----

### Flow of execution

<img src="https://raw.githubusercontent.com/junegunn/i/master/easy-align/usage.png" width="469">

There are two ways to use easy-align.

#### 1. `<Plug>` mappings (interactive mode)

The recommended method is to use `<Plug>(EasyAlign)` mapping in normal and
visual mode. They are usually mapped to `ga`, but you can choose any key
sequences.

```vim
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)
```

1. `ga` key in visual mode, or `ga` followed by a motion or a text
   object to start interactive mode
1. (Optional) Enter keys to cycle between alignment mode (left, right, or center)
1. (Optional) N-th delimiter (default: 1)
    - `1`         Around the 1st occurrences of delimiters
    - `2`         Around the 2nd occurrences of delimiters
    - ...
    - `*`         Around all occurrences of delimiters
    - `**`        Left-right alternating alignment around all delimiters
    - `-`         Around the last occurrences of delimiters (`-1`)
    - `-2`        Around the second to last occurrences of delimiters
    - ...
1. Delimiter key (a single keystroke; `<Space>`, `=`, `:`, `.`, `|`, `&`, `#`, `,`) or an arbitrary regular expression followed by `<CTRL-X>`

#### 2. Using `:EasyAlign` command

If you prefer command-line, use `:EasyAlign` command instead.

```vim
" Using predefined rules
:EasyAlign[!] [N-th] DELIMITER_KEY [OPTIONS]

" Using regular expression
:EasyAlign[!] [N-th] /REGEXP/ [OPTIONS]
```

### Regular expression vs. predefined rules

You can use regular expressions but it's usually much easier to use predefined
alignment rules that you can trigger with a single keystroke.

| Key       | Description/Use cases                                                |
| --------- | -------------------------------------------------------------------- |
| `<Space>` | General alignment around whitespaces                                 |
| `=`       | Operators containing equals sign (`=`, `==,` `!=`, `+=`, `&&=`, ...) |
| `:`       | Suitable for formatting JSON or YAML                                 |
| `.`       | Multi-line method chaining                                           |
| `,`       | Multi-line method arguments                                          |
| `&`       | LaTeX tables (matches `&` and `\\`)                                  |
| `#`       | Ruby/Python comments                                                 |
| `"`       | Vim comments                                                         |
| `<Bar>`   | Table markdown                                                       |

You can also define your own rules with `g:easy_align_delimiters` which will
be described in [the later section](#extending-alignment-rules).

----

### Interactive mode

Interactive mode is started either with `<Plug>(EasyAlign)` mapping or with
`:EasyAlign` command with no argument.

#### Examples using predefined rules

| Keystrokes   | Description                        | Equivalent command    |
| ------------ | ---------------------------------- | --------------------- |
| `<Space>`    | Around 1st whitespaces             | `:'<,'>EasyAlign\ `   |
| `2<Space>`   | Around 2nd whitespaces             | `:'<,'>EasyAlign2\ `  |
| `-<Space>`   | Around the last whitespaces        | `:'<,'>EasyAlign-\ `  |
| `-2<Space>`  | Around the 2nd to last whitespaces | `:'<,'>EasyAlign-2\ ` |
| `:`          | Around 1st colon (`key:  value`)   | `:'<,'>EasyAlign:`    |
| `<Right>:`   | Around 1st colon (`key : value`)   | `:'<,'>EasyAlign:>l1` |
| `=`          | Around 1st operators with =        | `:'<,'>EasyAlign=`    |
| `3=`         | Around 3rd operators with =        | `:'<,'>EasyAlign3=`   |
| `*=`         | Around all operators with =        | `:'<,'>EasyAlign*=`   |
| `**=`        | Left-right alternating around =    | `:'<,'>EasyAlign**=`  |
| `<Enter>=`   | Right alignment around 1st =       | `:'<,'>EasyAlign!=`   |
| `<Enter>**=` | Right-left alternating around =    | `:'<,'>EasyAlign!**=` |

Instead of finishing the alignment with a delimiter key, you can type in
a regular expression if you press `<CTRL-/>` or `<CTRL-X>`.

#### Alignment options in interactive mode

While in interactive mode, you can set alignment options using special shortcut
keys listed below. The meaning of each option will be described in
[the following sections](#alignment-options).

| Key       | Option             | Values                                             |
| --------- | ------------------ | -------------------------------------------------- |
| `CTRL-F`  | `filter`           | Input string (`[gv]/.*/?`)                         |
| `CTRL-I`  | `indentation`      | shallow, deep, none, keep                          |
| `CTRL-L`  | `left_margin`      | Input number or string                             |
| `CTRL-R`  | `right_margin`     | Input number or string                             |
| `CTRL-D`  | `delimiter_align`  | left, center, right                                |
| `CTRL-U`  | `ignore_unmatched` | 0, 1                                               |
| `CTRL-G`  | `ignore_groups`    | `[]`, `['String']`, `['Comment']`, `['String', 'Comment']` |
| `CTRL-A`  | `align`            | Input string (`/[lrc]+\*{0,2}/`)                   |
| `<Left>`  | `stick_to_left`    | `{ 'stick_to_left': 1, 'left_margin': 0 }`         |
| `<Right>` | `stick_to_left`    | `{ 'stick_to_left': 0, 'left_margin': 1 }`         |
| `<Down>`  | `*_margin`         | `{ 'left_margin': 0, 'right_margin': 0 }`          |

#### Live interactive mode

If you're performing a complex alignment where multiple options should be
carefully adjusted, try "live interactive mode" where you can preview the result
of the alignment on-the-fly as you type in.

Live interactive mode can be started with either `<Plug>(LiveEasyAlign)` map
or `:LiveEasyAlign` command. Or you can switch to live interactive mode while
in ordinary interactive mode by pressing `<CTRL-P>`. (P for Preview)

In live interactive mode, you have to type in the same delimiter (or
`<CTRL-X>` on regular expression) again to finalize the alignment. This allows
you to preview the result of the alignment and freely change the delimiter
using backspace key without leaving the interactive mode.

### :EasyAlign command

Instead of starting interactive mode, you can use non-interactive `:EasyAlign`
command.

```vim
" Using predefined alignment rules
"   :EasyAlign[!] [N-th] DELIMITER_KEY [OPTIONS]
:EasyAlign :
:EasyAlign =
:EasyAlign *=
:EasyAlign 3\

" Using arbitrary regular expressions
"   :EasyAlign[!] [N-th] /REGEXP/ [OPTIONS]
:EasyAlign /[:;]\+/
:EasyAlign 2/[:;]\+/
:EasyAlign */[:;]\+/
:EasyAlign **/[:;]\+/
```

A command can end with alignment options, [each of which will be discussed in
detail later](#alignment-options), in Vim dictionary format.

- `:EasyAlign * /[:;]\+/ { 'stick_to_left': 1, 'left_margin': 0 }`

`stick_to_left` of 1 means that the matched delimiter should be positioned right
next to the preceding token, and `left_margin` of 0 removes the margin on the
left. So we get:

    apple;: banana::   cake
    data;;  exchange:; format

You don't have to write complete names as long as they're distinguishable.

- `:EasyAlign * /[:;]\+/ { 'stl': 1, 'l': 0 }`

You can even omit spaces between the arguments.

- `:EasyAlign*/[:;]\+/{'s':1,'l':0}`

Nice. But let's make it even shorter. Option values can be written in shorthand
notation.

- `:EasyAlign*/[:;]\+/<l0`

The following table summarizes the shorthand notation.

| Option             | Expression     |
| ------------------ | -------------- |
| `filter`           | `[gv]/.*/`     |
| `left_margin`      | `l[0-9]+`      |
| `right_margin`     | `r[0-9]+`      |
| `stick_to_left`    | `<` or `>`     |
| `ignore_unmatched` | `iu[01]`       |
| `ignore_groups`    | `ig\[.*\]`     |
| `align`            | `a[lrc*]*`     |
| `delimiter_align`  | `d[lrc]`       |
| `indentation`      | `i[ksdn]`      |

### Partial alignment in blockwise-visual mode

In blockwise-visual mode (`CTRL-V`), EasyAlign command aligns only the selected
text in the block, instead of the whole lines in the range.

Consider the following case where you want to align text around `=>` operators.

```ruby
my_hash = { :a => 1,
            :aa => 2,
            :aaa => 3 }
```

In non-blockwise visual mode (`v` / `V`), `<Enter>=` won't work since the
assignment operator in the first line gets in the way. So we instead enter
blockwise-visual mode (`CTRL-V`), and select the text *around*
`=>` operators, then press `<Enter>=`.

```ruby
my_hash = { :a   => 1,
            :aa  => 2,
            :aaa => 3 }
```

However, in this case, we don't really need blockwise visual mode
since the same can be easily done using the negative N-th parameter: `<Enter>-=`


Alignment options
-----------------

### List of options

| Option             | Type    | Default               | Description                                             |
| ------------------ | ------- | --------------------- | ------------------------------------------------------- |
| `filter`           | string  |                       | Line filtering expression: `g/../` or `v/../`           |
| `left_margin`      | number  | 1                     | Number of spaces to attach before delimiter             |
| `left_margin`      | string  | `' '`                 | String to attach before delimiter                       |
| `right_margin`     | number  | 1                     | Number of spaces to attach after delimiter              |
| `right_margin`     | string  | `' '`                 | String to attach after delimiter                        |
| `stick_to_left`    | boolean | 0                     | Whether to position delimiter on the left-side          |
| `ignore_groups`    | list    | ['String', 'Comment'] | Delimiters in these syntax highlight groups are ignored |
| `ignore_unmatched` | boolean | 1                     | Whether to ignore lines without matching delimiter      |
| `indentation`      | string  | `k`                   | Indentation method (*k*eep, *d*eep, *s*hallow, *n*one)  |
| `delimiter_align`  | string  | `r`                   | Determines how to align delimiters of different lengths |
| `align`            | string  | `l`                   | Alignment modes for multiple occurrences of delimiters  |

There are 4 ways to set alignment options (from lowest precedence to highest):

1. Some option values can be set with corresponding global variables
2. Option values can be specified in the definition of each alignment rule
3. Option values can be given as arguments to `:EasyAlign` command
4. Option values can be set in interactive mode using special shortcut keys

| Option name        | Shortcut key        | Abbreviated    | Global variable                 |
| ------------------ | ------------------- | -------------- | ------------------------------- |
| `filter`           | `CTRL-F`            | `[gv]/.*/`     |                                 |
| `left_margin`      | `CTRL-L`            | `l[0-9]+`      |                                 |
| `right_margin`     | `CTRL-R`            | `r[0-9]+`      |                                 |
| `stick_to_left`    | `<Left>`, `<Right>` | `<` or `>`     |                                 |
| `ignore_groups`    | `CTRL-G`            | `ig\[.*\]`     | `g:easy_align_ignore_groups`    |
| `ignore_unmatched` | `CTRL-U`            | `iu[01]`       | `g:easy_align_ignore_unmatched` |
| `indentation`      | `CTRL-I`            | `i[ksdn]`      | `g:easy_align_indentation`      |
| `delimiter_align`  | `CTRL-D`            | `d[lrc]`       | `g:easy_align_delimiter_align`  |
| `align`            | `CTRL-A`            | `a[lrc*]*`     |                                 |

### Filtering lines

With `filter` option, you can align lines that only match or do not match a
given pattern. There are several ways to set the pattern.

1. Press `CTRL-F` in interactive mode and type in `g/pat/` or `v/pat/`
2. In command-line, it can be written in dictionary format: `{'filter': 'g/pat/'}`
3. Or in shorthand notation: `g/pat/` or `v/pat/`

(You don't need to escape '/'s in the regular expression)

#### Examples

```vim
" Start interactive mode with filter option set to g/hello/
EasyAlign g/hello/

" Start live interactive mode with filter option set to v/goodbye/
LiveEasyAlign v/goodbye/

" Align the lines with 'hi' around the first colons
EasyAlign:g/hi/
```

### Ignoring delimiters in comments or strings

EasyAlign can be configured to ignore delimiters in certain syntax highlight
groups, such as code comments or strings. By default, delimiters that are
highlighted as code comments or strings are ignored.

```vim
" Default:
"   If a delimiter is in a highlight group whose name matches
"   any of the followings, it will be ignored.
let g:easy_align_ignore_groups = ['Comment', 'String']
```

For example, the following paragraph

```ruby
{
  # Quantity of apples: 1
  apple: 1,
  # Quantity of bananas: 2
  bananas: 2,
  # Quantity of grape:fruits: 3
  'grape:fruits': 3
}
```

becomes as follows on `<Enter>:` (or `:EasyAlign:`)

```ruby
{
  # Quantity of apples: 1
  apple:          1,
  # Quantity of bananas: 2
  bananas:        2,
  # Quantity of grape:fruits: 3
  'grape:fruits': 3
}
```

Naturally, this feature only works when syntax highlighting is enabled.

You can change the default rule by using one of these 4 methods.

1. Press `CTRL-G` in interactive mode to switch groups
2. Define global `g:easy_align_ignore_groups` list
3. Define a custom rule in `g:easy_align_delimiters` with `ignore_groups` option
4. Provide `ignore_groups` option to `:EasyAlign` command.
   e.g. `:EasyAlign:ig[]`

For example if you set `ignore_groups` option to be an empty list, you get

```ruby
{
  # Quantity of apples:  1
  apple:                 1,
  # Quantity of bananas: 2
  bananas:               2,
  # Quantity of grape:   fruits: 3
  'grape:                fruits': 3
}
```

If a pattern in `ignore_groups` is prepended by a `!`, it will have the opposite
meaning. For instance, if `ignore_groups` is given as `['!Comment']`, delimiters
that are *not* highlighted as Comment will be ignored during the alignment.

### Ignoring unmatched lines

`ignore_unmatched` option determines how EasyAlign command processes lines that
do not have N-th delimiter.

1. In left-alignment mode, they are ignored
2. In right or center-alignment mode, they are *not* ignored, and the last
   tokens from those lines are aligned as well as if there is an invisible
   trailing delimiter at the end of each line
3. If `ignore_unmatched` is 1, they are ignored regardless of the alignment mode
4. If `ignore_unmatched` is 0, they are *not* ignored regardless of the mode

Let's take an example.
When we align the following code block around the (1st) colons,

```ruby
{
  apple: proc {
    this_line_does_not_have_a_colon
  },
  bananas: 2,
  grapefruits: 3
}
```

this is usually what we want.

```ruby
{
  apple:       proc {
    this_line_does_not_have_a_colon
  },
  bananas:     2,
  grapefruits: 3
}
```

However, we can override this default behavior by setting `ignore_unmatched`
option to zero using one of the following methods.

1. Press `CTRL-U` in interactive mode to toggle `ignore_unmatched` option
2. Set the global `g:easy_align_ignore_unmatched` variable to 0
3. Define a custom alignment rule with `ignore_unmatched` option set to 0
4. Provide `ignore_unmatched` option to `:EasyAlign` command. e.g. `:EasyAlign:iu0`

Then we get,

```ruby
{
  apple:                             proc {
    this_line_does_not_have_a_colon
  },
  bananas:                           2,
  grapefruits:                       3
}
```

### Aligning delimiters of different lengths

Global `g:easy_align_delimiter_align` option and rule-wise/command-wise
`delimiter_align` option determines how matched delimiters of different lengths
are aligned.

```ruby
apple = 1
banana += apple
cake ||= banana
```

By default, delimiters are right-aligned as follows.

```ruby
apple    = 1
banana  += apple
cake   ||= banana
```

However, with `:EasyAlign=dl`, delimiters are left-aligned.

```ruby
apple  =   1
banana +=  apple
cake   ||= banana
```

And on `:EasyAlign=dc`, center-aligned.

```ruby
apple   =  1
banana +=  apple
cake   ||= banana
```

In interactive mode, you can change the option value with `CTRL-D` key.

### Adjusting indentation

By default :EasyAlign command keeps the original indentation of the lines. But
then again we have `indentation` option. See the following example.

```ruby
# Lines with different indentation
  apple = 1
    banana = 2
      cake = 3
        daisy = 4
     eggplant = 5

# Default: _k_eep the original indentation
#   :EasyAlign=
  apple       = 1
    banana    = 2
      cake    = 3
        daisy = 4
     eggplant = 5

# Use the _s_hallowest indentation among the lines
#   :EasyAlign=is
  apple    = 1
  banana   = 2
  cake     = 3
  daisy    = 4
  eggplant = 5

# Use the _d_eepest indentation among the lines
#   :EasyAlign=id
        apple    = 1
        banana   = 2
        cake     = 3
        daisy    = 4
        eggplant = 5

# Indentation: _n_one
#   :EasyAlign=in
apple    = 1
banana   = 2
cake     = 3
daisy    = 4
eggplant = 5
```

In interactive mode, you can change the option value with `CTRL-I` key.

### Alignments over multiple occurrences of delimiters

As stated above, "N-th" parameter is used to target specific occurrences of
the delimiter when it appears multiple times in each line.

To recap:

```vim
" Left-alignment around the FIRST occurrences of delimiters
:EasyAlign =

" Left-alignment around the SECOND occurrences of delimiters
:EasyAlign 2=

" Left-alignment around the LAST occurrences of delimiters
:EasyAlign -=

" Left-alignment around ALL occurrences of delimiters
:EasyAlign *=

" Left-right ALTERNATING alignment around all occurrences of delimiters
:EasyAlign **=

" Right-left ALTERNATING alignment around all occurrences of delimiters
:EasyAlign! **=
```

In addition to these, you can fine-tune alignments over multiple occurrences
of the delimiters with 'align' option. (The option can also be set in
interactive mode with the special key `CTRL-A`)

```vim
" Left alignment over the first two occurrences of delimiters
:EasyAlign = { 'align': 'll' }

" Right, left, center alignment over the 1st to 3rd occurrences of delimiters
:EasyAlign = { 'a': 'rlc' }

" Using shorthand notation
:EasyAlign = arlc

" Right, left, center alignment over the 2nd to 4th occurrences of delimiters
:EasyAlign 2=arlc

" (*) Repeating alignments (default: l, r, or c)
"   Right, left, center, center, center, center, ...
:EasyAlign *=arlc

" (**) Alternating alignments (default: lr or rl)
"   Right, left, center, right, left, center, ...
:EasyAlign **=arlc

" Right, left, center, center, center, ... repeating alignment
" over the 3rd to the last occurrences of delimiters
:EasyAlign 3=arlc*

" Right, left, center, right, left, center, ... alternating alignment
" over the 3rd to the last occurrences of delimiters
:EasyAlign 3=arlc**
```

### Extending alignment rules

Although the default rules should cover the most of the use cases,
you can extend the rules by setting a dictionary named `g:easy_align_delimiters`.

You may refer to the definitions of the default alignment rules
[here](https://github.com/junegunn/vim-easy-align/blob/2.9.6/autoload/easy_align.vim#L32-L46).

#### Examples

```vim
let g:easy_align_delimiters = {
\ '>': { 'pattern': '>>\|=>\|>' },
\ '/': {
\     'pattern':         '//\+\|/\*\|\*/',
\     'delimiter_align': 'l',
\     'ignore_groups':   ['!Comment'] },
\ ']': {
\     'pattern':       '[[\]]',
\     'left_margin':   0,
\     'right_margin':  0,
\     'stick_to_left': 0
\   },
\ ')': {
\     'pattern':       '[()]',
\     'left_margin':   0,
\     'right_margin':  0,
\     'stick_to_left': 0
\   },
\ 'd': {
\     'pattern':      ' \(\S\+\s*[;=]\)\@=',
\     'left_margin':  0,
\     'right_margin': 0
\   }
\ }
```

Other options
-------------

### Disabling &foldmethod during alignment

[It is reported](https://github.com/junegunn/vim-easy-align/issues/14) that
`&foldmethod` value of `expr` or `syntax` can significantly slow down the
alignment when editing a large, complex file with many folds. To alleviate this
issue, EasyAlign provides an option to temporarily set `&foldmethod` to `manual`
during the alignment task. In order to enable this feature, set
`g:easy_align_bypass_fold` switch to 1.

```vim
let g:easy_align_bypass_fold = 1
```

### Left/right/center mode switch in interactive mode

In interactive mode, you can choose the alignment mode you want by pressing
enter keys. The non-bang command, `:EasyAlign` starts in left-alignment mode
and changes to right and center mode as you press enter keys, while the bang
version first starts in right-alignment mode.

- `:EasyAlign`
  - Left, Right, Center
- `:EasyAlign!`
  - Right, Left, Center

If you do not prefer this default mode transition, you can define your own
settings as follows.

```vim
let g:easy_align_interactive_modes = ['l', 'r']
let g:easy_align_bang_interactive_modes = ['c', 'r']
```

Advanced examples and use cases
-------------------------------

See [EXAMPLES.md](https://github.com/junegunn/vim-easy-align/blob/master/EXAMPLES.md)
for more examples.

Related work
------------

- [DrChip's Alignment Tool for Vim](http://www.drchip.org/astronaut/vim/align.html)
- [Tabular](https://github.com/godlygeek/tabular)

Author
------

[Junegunn Choi](https://github.com/junegunn)

License
-------

MIT
./autoload/easy_align.vim	[[[1
1148
" Copyright (c) 2014 Junegunn Choi
"
" MIT License
"
" Permission is hereby granted, free of charge, to any person obtaining
" a copy of this software and associated documentation files (the
" "Software"), to deal in the Software without restriction, including
" without limitation the rights to use, copy, modify, merge, publish,
" distribute, sublicense, and/or sell copies of the Software, and to
" permit persons to whom the Software is furnished to do so, subject to
" the following conditions:
"
" The above copyright notice and this permission notice shall be
" included in all copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
" EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
" MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
" NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
" LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
" OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
" WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

if exists("g:loaded_easy_align")
  finish
endif
let g:loaded_easy_align = 1

let s:cpo_save = &cpo
set cpo&vim

let s:easy_align_delimiters_default = {
\  ' ': { 'pattern': ' ',  'left_margin': 0, 'right_margin': 0, 'stick_to_left': 0 },
\  '=': { 'pattern': '===\|<=>\|\(&&\|||\|<<\|>>\)=\|=\~[#?]\?\|=>\|[:+/*!%^=><&|.?-]\?=[#?]\?',
\                          'left_margin': 1, 'right_margin': 1, 'stick_to_left': 0 },
\  ':': { 'pattern': ':',  'left_margin': 0, 'right_margin': 1, 'stick_to_left': 1 },
\  ',': { 'pattern': ',',  'left_margin': 0, 'right_margin': 1, 'stick_to_left': 1 },
\  '|': { 'pattern': '|',  'left_margin': 1, 'right_margin': 1, 'stick_to_left': 0 },
\  '.': { 'pattern': '\.', 'left_margin': 0, 'right_margin': 0, 'stick_to_left': 0 },
\  '#': { 'pattern': '#\+', 'delimiter_align': 'l', 'ignore_groups': ['!Comment']  },
\  '"': { 'pattern': '"\+', 'delimiter_align': 'l', 'ignore_groups': ['!Comment']  },
\  '&': { 'pattern': '\\\@<!&\|\\\\',
\                          'left_margin': 1, 'right_margin': 1, 'stick_to_left': 0 },
\  '{': { 'pattern': '(\@<!{',
\                          'left_margin': 1, 'right_margin': 1, 'stick_to_left': 0 },
\  '}': { 'pattern': '}',  'left_margin': 1, 'right_margin': 0, 'stick_to_left': 0 }
\ }

let s:mode_labels = { 'l': '', 'r': '[R]', 'c': '[C]' }

let s:known_options = {
\ 'margin_left':   [0, 1], 'margin_right':     [0, 1], 'stick_to_left':   [0],
\ 'left_margin':   [0, 1], 'right_margin':     [0, 1], 'indentation':     [1],
\ 'ignore_groups': [3   ], 'ignore_unmatched': [0   ], 'delimiter_align': [1],
\ 'mode_sequence': [1   ], 'ignores':          [3],    'filter':          [1],
\ 'align':         [1   ]
\ }

let s:option_values = {
\ 'indentation':      ['shallow', 'deep', 'none', 'keep', -1],
\ 'delimiter_align':  ['left', 'center', 'right', -1],
\ 'ignore_unmatched': [0, 1, -1],
\ 'ignore_groups':    [[], ['String'], ['Comment'], ['String', 'Comment'], -1]
\ }

let s:shorthand = {
\ 'margin_left':   'lm', 'margin_right':     'rm', 'stick_to_left':   'stl',
\ 'left_margin':   'lm', 'right_margin':     'rm', 'indentation':     'idt',
\ 'ignore_groups': 'ig', 'ignore_unmatched': 'iu', 'delimiter_align': 'da',
\ 'mode_sequence': 'a',  'ignores':          'ig', 'filter':          'f',
\ 'align':         'a'
\ }

if exists("*strdisplaywidth")
  function! s:strwidth(str)
    return strdisplaywidth(a:str)
  endfunction
else
  function! s:strwidth(str)
    return len(split(a:str, '\zs')) + len(matchstr(a:str, '^\t*')) * (&tabstop - 1)
  endfunction
endif

function! s:ceil2(v)
  return a:v % 2 == 0 ? a:v : a:v + 1
endfunction

function! s:floor2(v)
  return a:v % 2 == 0 ? a:v : a:v - 1
endfunction

function! s:highlighted_as(line, col, groups)
  if empty(a:groups) | return 0 | endif
  let hl = synIDattr(synID(a:line, a:col, 0), 'name')
  for grp in a:groups
    if grp[0] == '!'
      if hl !~# grp[1:-1]
        return 1
      endif
    elseif hl =~# grp
      return 1
    endif
  endfor
  return 0
endfunction

function! s:ignored_syntax()
  if has('syntax') && exists('g:syntax_on')
    " Backward-compatibility
    return get(g:, 'easy_align_ignore_groups',
          \ get(g:, 'easy_align_ignores',
            \ (get(g:, 'easy_align_ignore_comment', 1) == 0) ?
              \ ['String'] : ['String', 'Comment']))
  else
    return []
  endif
endfunction

function! s:echon_(tokens)
  " http://vim.wikia.com/wiki/How_to_print_full_screen_width_messages
  let xy = [&ruler, &showcmd]
  try
    set noruler noshowcmd

    let winlen = winwidth(winnr()) - 2
    let len = len(join(map(copy(a:tokens), 'v:val[1]'), ''))
    let ellipsis = len > winlen ? '..' : ''

    echon "\r"
    let yet = 0
    for [hl, msg] in a:tokens
      if empty(msg) | continue | endif
      execute "echohl ". hl
      let yet += len(msg)
      if yet > winlen - len(ellipsis)
        echon msg[ 0 : (winlen - len(ellipsis) - yet - 1) ] . ellipsis
        break
      else
        echon msg
      endif
    endfor
  finally
    echohl None
    let [&ruler, &showcmd] = xy
  endtry
endfunction

function! s:echon(l, n, r, d, o, warn)
  let tokens = [
  \ ['Function', s:live ? ':LiveEasyAlign' : ':EasyAlign'],
  \ ['ModeMsg', get(s:mode_labels, a:l, a:l)],
  \ ['None', ' ']]

  if a:r == -1 | call add(tokens, ['Comment', '(']) | endif
  call add(tokens, [a:n =~ '*' ? 'Repeat' : 'Number', a:n])
  call extend(tokens, a:r == 1 ?
  \ [['Delimiter', '/'], ['String', a:d], ['Delimiter', '/']] :
  \ [['Identifier', a:d == ' ' ? '\ ' : (a:d == '\' ? '\\' : a:d)]])
  if a:r == -1 | call extend(tokens, [['Normal', '_'], ['Comment', ')']]) | endif
  call add(tokens, ['Statement', empty(a:o) ? '' : ' '.string(a:o)])
  if !empty(a:warn)
    call add(tokens, ['WarningMsg', ' ('.a:warn.')'])
  endif

  call s:echon_(tokens)
  return join(map(tokens, 'v:val[1]'), '')
endfunction

function! s:exit(msg)
  call s:echon_([['ErrorMsg', a:msg]])
  throw 'exit'
endfunction

function! s:ltrim(str)
  return substitute(a:str, '^\s\+', '', '')
endfunction

function! s:rtrim(str)
  return substitute(a:str, '\s\+$', '', '')
endfunction

function! s:trim(str)
  return substitute(a:str, '^\s*\(.\{-}\)\s*$', '\1', '')
endfunction

function! s:fuzzy_lu(key)
  if has_key(s:known_options, a:key)
    return a:key
  endif
  let key = tolower(a:key)

  " stl -> ^s.*_t.*_l.*
  let regexp1 = '^' .key[0]. '.*' .substitute(key[1 : -1], '\(.\)', '_\1.*', 'g')
  let matches = filter(keys(s:known_options), 'v:val =~ regexp1')
  if len(matches) == 1
    return matches[0]
  endif

  " stl -> ^s.*t.*l.*
  let regexp2 = '^' . substitute(substitute(key, '-', '_', 'g'), '\(.\)', '\1.*', 'g')
  let matches = filter(keys(s:known_options), 'v:val =~ regexp2')

  if empty(matches)
    call s:exit("Unknown option key: ". a:key)
  elseif len(matches) == 1
    return matches[0]
  else
    " Avoid ambiguity introduced by deprecated margin_left and margin_right
    if sort(matches) == ['margin_left', 'margin_right', 'mode_sequence']
      return 'mode_sequence'
    endif
    if sort(matches) == ['ignore_groups', 'ignores']
      return 'ignore_groups'
    endif
    call s:exit("Ambiguous option key: ". a:key ." (" .join(matches, ', '). ")")
  endif
endfunction

function! s:shift(modes, cycle)
  let item = remove(a:modes, 0)
  if a:cycle || empty(a:modes)
    call add(a:modes, item)
  endif
  return item
endfunction

function! s:normalize_options(opts)
  let ret = {}
  for k in keys(a:opts)
    let v = a:opts[k]
    let k = s:fuzzy_lu(k)
    " Backward-compatibility
    if k == 'margin_left'   | let k = 'left_margin'    | endif
    if k == 'margin_right'  | let k = 'right_margin'   | endif
    if k == 'mode_sequence' | let k = 'align'          | endif
    let ret[k] = v
    unlet v
  endfor
  return s:validate_options(ret)
endfunction

function! s:compact_options(opts)
  let ret = {}
  for k in keys(a:opts)
    let ret[s:shorthand[k]] = a:opts[k]
  endfor
  return ret
endfunction

function! s:validate_options(opts)
  for k in keys(a:opts)
    let v = a:opts[k]
    if index(s:known_options[k], type(v)) == -1
      call s:exit("Invalid type for option: ". k)
    endif
    unlet v
  endfor
  return a:opts
endfunction

function! s:split_line(line, nth, modes, cycle, fc, lc, pattern, stick_to_left, ignore_unmatched, ignore_groups)
  let mode = ''

  let string = a:lc ?
    \ strpart(getline(a:line), a:fc - 1, a:lc - a:fc + 1) :
    \ strpart(getline(a:line), a:fc - 1)
  let idx     = 0
  let nomagic = match(a:pattern, '\\v') > match(a:pattern, '\C\\[mMV]')
  let pattern = '^.\{-}\s*\zs\('.a:pattern.(nomagic ? ')' : '\)')
  let tokens  = []
  let delims  = []

  " Phase 1: split
  let ignorable = 0
  let token = ''
  let phantom = 0
  while 1
    let matchidx = match(string, pattern, idx)
    " No match
    if matchidx < 0 | break | endif
    let matchend = matchend(string, pattern, idx)
    let spaces = matchstr(string, '\s'.(a:stick_to_left ? '*' : '\{-}'), matchend + (matchidx == matchend))

    " Match, but empty
    if len(spaces) + matchend - idx == 0
      let char = strpart(string, idx, 1)
      if empty(char) | break | endif
      let [match, part, delim] = [char, char, '']
    " Match
    else
      let match = strpart(string, idx, matchend - idx + len(spaces))
      let part  = strpart(string, idx, matchidx - idx)
      let delim = strpart(string, matchidx, matchend - matchidx)
    endif

    let ignorable = s:highlighted_as(a:line, idx + len(part) + a:fc, a:ignore_groups)
    if ignorable
      let token .= match
    else
      let [pmode, mode] = [mode, s:shift(a:modes, a:cycle)]
      call add(tokens, token . match)
      call add(delims, delim)
      let token = ''
    endif

    let idx += len(match)

    " If the string is non-empty and ends with the delimiter,
    " append an empty token to the list
    if idx == len(string)
      let phantom = 1
      break
    endif
  endwhile

  let leftover = token . strpart(string, idx)
  if !empty(leftover)
    let ignorable = s:highlighted_as(a:line, len(string) + a:fc - 1, a:ignore_groups)
    call add(tokens, leftover)
    call add(delims, '')
  elseif phantom
    call add(tokens, '')
    call add(delims, '')
  endif
  let [pmode, mode] = [mode, s:shift(a:modes, a:cycle)]

  " Preserve indentation - merge first two tokens
  if len(tokens) > 1 && empty(s:rtrim(tokens[0]))
    let tokens[1] = tokens[0] . tokens[1]
    call remove(tokens, 0)
    call remove(delims, 0)
    let mode = pmode
  endif

  " Skip comment line
  if ignorable && len(tokens) == 1 && a:ignore_unmatched
    let tokens = []
    let delims = []
  " Append an empty item to enable right/center alignment of the last token
  " - if the last token is not ignorable or ignorable but not the only token
  elseif a:ignore_unmatched != 1          &&
        \ (mode ==? 'r' || mode ==? 'c')  &&
        \ (!ignorable || len(tokens) > 1) &&
        \ a:nth >= 0 " includes -0
    call add(tokens, '')
    call add(delims, '')
  endif

  return [tokens, delims]
endfunction

function! s:do_align(todo, modes, all_tokens, all_delims, fl, ll, fc, lc, nth, recur, dict)
  let mode       = a:modes[0]
  let lines      = {}
  let min_indent = -1
  let max = { 'pivot_len2': 0, 'token_len': 0, 'just_len': 0, 'delim_len': 0,
        \ 'indent': 0, 'tokens': 0, 'strip_len': 0 }
  let d = a:dict
  let [f, fx] = s:parse_filter(d.filter)

  " Phase 1
  for line in range(a:fl, a:ll)
    let snip = a:lc > 0 ? getline(line)[a:fc-1 : a:lc-1] : getline(line)
    if f == 1 && snip !~ fx
      continue
    elseif f == -1 && snip =~ fx
      continue
    endif

    if !has_key(a:all_tokens, line)
      " Split line into the tokens by the delimiters
      let [tokens, delims] = s:split_line(
            \ line, a:nth, copy(a:modes), a:recur == 2,
            \ a:fc, a:lc, d.pattern,
            \ d.stick_to_left, d.ignore_unmatched, d.ignore_groups)

      " Remember tokens for subsequent recursive calls
      let a:all_tokens[line] = tokens
      let a:all_delims[line] = delims
    else
      let tokens = a:all_tokens[line]
      let delims = a:all_delims[line]
    endif

    " Skip empty lines
    if empty(tokens)
      continue
    endif

    " Calculate the maximum number of tokens for a line within the range
    let max.tokens = max([max.tokens, len(tokens)])

    if a:nth > 0 " Positive N-th
      if len(tokens) < a:nth
        continue
      endif
      let nth = a:nth - 1 " make it 0-based
    else " -0 or Negative N-th
      if a:nth == 0 && mode !=? 'l'
        let nth = len(tokens) - 1
      else
        let nth = len(tokens) + a:nth
      endif
      if empty(delims[len(delims) - 1])
        let nth -= 1
      endif

      if nth < 0 || nth == len(tokens)
        continue
      endif
    endif

    let prefix = nth > 0 ? join(tokens[0 : nth - 1], '') : ''
    let delim  = delims[nth]
    let token  = s:rtrim( tokens[nth] )
    let token  = s:rtrim( strpart(token, 0, len(token) - len(s:rtrim(delim))) )
    if empty(delim) && !exists('tokens[nth + 1]') && d.ignore_unmatched
      continue
    endif

    let indent = s:strwidth(matchstr(tokens[0], '^\s*'))
    if min_indent < 0 || indent < min_indent
      let min_indent  = indent
    endif
    if mode ==? 'c'
      let token .= substitute(matchstr(token, '^\s*'), '\t', repeat(' ', &tabstop), 'g')
    endif
    let [pw, tw] = [s:strwidth(prefix), s:strwidth(token)]
    let max.indent    = max([max.indent,    indent])
    let max.token_len = max([max.token_len, tw])
    let max.just_len  = max([max.just_len,  pw + tw])
    let max.delim_len = max([max.delim_len, s:strwidth(delim)])

    if mode ==? 'c'
      let pivot_len2 = pw * 2 + tw
      if max.pivot_len2 < pivot_len2
        let max.pivot_len2 = pivot_len2
      endif
      let max.strip_len = max([max.strip_len, s:strwidth(s:trim(token))])
    endif
    let lines[line]   = [nth, prefix, token, delim]
  endfor

  " Phase 1-5: indentation handling (only on a:nth == 1)
  if a:nth == 1
    let idt = d.indentation
    if idt ==? 'd'
      let indent = max.indent
    elseif idt ==? 's'
      let indent = min_indent
    elseif idt ==? 'n'
      let indent = 0
    elseif idt !=? 'k'
      call s:exit('Invalid indentation: ' . idt)
    end

    if idt !=? 'k'
      let max.just_len   = 0
      let max.token_len  = 0
      let max.pivot_len2 = 0

      for [line, elems] in items(lines)
        let [nth, prefix, token, delim] = elems

        let tindent = matchstr(token, '^\s*')
        while 1
          let len = s:strwidth(tindent)
          if len < indent
            let tindent .= repeat(' ', indent - len)
            break
          elseif len > indent
            let tindent = tindent[0 : -2]
          else
            break
          endif
        endwhile

        let token = tindent . s:ltrim(token)
        if mode ==? 'c'
          let token = substitute(token, '\s*$', repeat(' ', indent), '')
        endif
        let [pw, tw] = [s:strwidth(prefix), s:strwidth(token)]
        let max.token_len = max([max.token_len, tw])
        let max.just_len  = max([max.just_len,  pw + tw])
        if mode ==? 'c'
          let pivot_len2 = pw * 2 + tw
          if max.pivot_len2 < pivot_len2
            let max.pivot_len2 = pivot_len2
          endif
        endif

        let lines[line][2] = token
      endfor
    endif
  endif

  " Phase 2
  for [line, elems] in items(lines)
    let tokens = a:all_tokens[line]
    let delims = a:all_delims[line]
    let [nth, prefix, token, delim] = elems

    " Remove the leading whitespaces of the next token
    if len(tokens) > nth + 1
      let tokens[nth + 1] = s:ltrim(tokens[nth + 1])
    endif

    " Pad the token with spaces
    let [pw, tw] = [s:strwidth(prefix), s:strwidth(token)]
    let rpad = ''
    if mode ==? 'l'
      let pad = repeat(' ', max.just_len - pw - tw)
      if d.stick_to_left
        let rpad = pad
      else
        let token = token . pad
      endif
    elseif mode ==? 'r'
      let pad = repeat(' ', max.just_len - pw - tw)
      let indent = matchstr(token, '^\s*')
      let token = indent . pad . s:ltrim(token)
    elseif mode ==? 'c'
      let p1  = max.pivot_len2 - (pw * 2 + tw)
      let p2  = max.token_len - tw
      let pf1 = s:floor2(p1)
      if pf1 < p1 | let p2 = s:ceil2(p2)
      else        | let p2 = s:floor2(p2)
      endif
      let strip = s:ceil2(max.token_len - max.strip_len) / 2
      let indent = matchstr(token, '^\s*')
      let token = indent. repeat(' ', pf1 / 2) .s:ltrim(token). repeat(' ', p2 / 2)
      let token = substitute(token, repeat(' ', strip) . '$', '', '')

      if d.stick_to_left
        if empty(s:rtrim(token))
          let center = len(token) / 2
          let [token, rpad] = [strpart(token, 0, center), strpart(token, center)]
        else
          let [token, rpad] = [s:rtrim(token), matchstr(token, '\s*$')]
        endif
      endif
    endif
    let tokens[nth] = token

    " Pad the delimiter
    let dpadl = max.delim_len - s:strwidth(delim)
    let da = d.delimiter_align
    if da ==? 'l'
      let [dl, dr] = ['', repeat(' ', dpadl)]
    elseif da ==? 'c'
      let dl = repeat(' ', dpadl / 2)
      let dr = repeat(' ', dpadl - dpadl / 2)
    elseif da ==? 'r'
      let [dl, dr] = [repeat(' ', dpadl), '']
    else
      call s:exit('Invalid delimiter_align: ' . da)
    endif

    " Before and after the range (for blockwise visual mode)
    let cline  = getline(line)
    let before = strpart(cline, 0, a:fc - 1)
    let after  = a:lc ? strpart(cline, a:lc) : ''

    " Determine the left and right margin around the delimiter
    let rest   = join(tokens[nth + 1 : -1], '')
    let nomore = empty(rest.after)
    let ml     = (empty(prefix . token) || empty(delim) && nomore) ? '' : d.ml
    let mr     = nomore ? '' : d.mr

    " Adjust indentation of the lines starting with a delimiter
    let lpad = ''
    if nth == 0
      let ipad = repeat(' ', min_indent - s:strwidth(token.ml))
      if mode ==? 'l'
        let token = ipad . token
      else
        let lpad = ipad
      endif
    endif

    " Align the token
    let aligned = join([lpad, token, ml, dl, delim, dr, mr, rpad], '')
    let tokens[nth] = aligned

    " Update the line
    let a:todo[line] = before.join(tokens, '').after
  endfor

  if a:nth < max.tokens && (a:recur || len(a:modes) > 1)
    call s:shift(a:modes, a:recur == 2)
    return [a:todo, a:modes, a:all_tokens, a:all_delims,
          \ a:fl, a:ll, a:fc, a:lc, a:nth + 1, a:recur, a:dict]
  endif
  return [a:todo]
endfunction

function! s:input(str, default, vis)
  if a:vis
    normal! gv
    redraw
    execute "normal! \<esc>"
  else
    " EasyAlign command can be called without visual selection
    redraw
  endif
  let got = input(a:str, a:default)
  return got
endfunction

function! s:atoi(str)
  return (a:str =~ '^[0-9]\+$') ? str2nr(a:str) : a:str
endfunction

function! s:shift_opts(opts, key, vals)
  let val = s:shift(a:vals, 1)
  if type(val) == 0 && val == -1
    call remove(a:opts, a:key)
  else
    let a:opts[a:key] = val
  endif
endfunction

function! s:interactive(range, modes, n, d, opts, rules, vis, bvis)
  let mode = s:shift(a:modes, 1)
  let n    = a:n
  let d    = a:d
  let ch   = ''
  let opts = s:compact_options(a:opts)
  let vals = deepcopy(s:option_values)
  let regx = 0
  let warn = ''
  let undo = 0

  while 1
    " Live preview
    let rdrw = 0
    if undo
      silent! undo
      let undo = 0
      let rdrw = 1
    endif
    if s:live && !empty(d)
      let output = s:process(a:range, mode, n, d, s:normalize_options(opts), regx, a:rules, a:bvis)
      let &undolevels = &undolevels " Break undo block
      call s:update_lines(output.todo)
      let undo = !empty(output.todo)
      let rdrw = 1
    endif
    if rdrw
      if a:vis
        normal! gv
      endif
      redraw
      if a:vis | execute "normal! \<esc>" | endif
    endif
    call s:echon(mode, n, -1, regx ? '/'.d.'/' : d, opts, warn)

    let check = 0
    let warn = ''

    try
      let c = getchar()
    catch /^Vim:Interrupt$/
      let c = 27
    endtry
    let ch = nr2char(c)
    if c == 3 || c == 27 " CTRL-C / ESC
      if undo
        silent! undo
      endif
      throw 'exit'
    elseif c == "\<bs>"
      if !empty(d)
        let d = ''
        let regx = 0
      elseif len(n) > 0
        let n = strpart(n, 0, len(n) - 1)
      endif
    elseif c == 13 " Enter key
      let mode = s:shift(a:modes, 1)
      if has_key(opts, 'a')
        let opts.a = mode . strpart(opts.a, 1)
      endif
    elseif ch == '-'
      if empty(n)      | let n = '-'
      elseif n == '-'  | let n = ''
      else             | let check = 1
      endif
    elseif ch == '*'
      if empty(n)      | let n = '*'
      elseif n == '*'  | let n = '**'
      elseif n == '**' | let n = ''
      else             | let check = 1
      endif
    elseif empty(d) && ((c == 48 && len(n) > 0) || c > 48 && c <= 57) " Numbers
      if n[0] == '*'   | let check = 1
      else             | let n = n . ch
      end
    elseif ch == "\<C-D>"
      call s:shift_opts(opts, 'da', vals['delimiter_align'])
    elseif ch == "\<C-I>"
      call s:shift_opts(opts, 'idt', vals['indentation'])
    elseif ch == "\<C-L>"
      let lm = s:input("Left margin: ", get(opts, 'lm', ''), a:vis)
      if empty(lm)
        let warn = 'Set to default. Input 0 to remove it'
        silent! call remove(opts, 'lm')
      else
        let opts['lm'] = s:atoi(lm)
      endif
    elseif ch == "\<C-R>"
      let rm = s:input("Right margin: ", get(opts, 'rm', ''), a:vis)
      if empty(rm)
        let warn = 'Set to default. Input 0 to remove it'
        silent! call remove(opts, 'rm')
      else
        let opts['rm'] = s:atoi(rm)
      endif
    elseif ch == "\<C-U>"
      call s:shift_opts(opts, 'iu', vals['ignore_unmatched'])
    elseif ch == "\<C-G>"
      call s:shift_opts(opts, 'ig', vals['ignore_groups'])
    elseif ch == "\<C-P>"
      if s:live
        if !empty(d)
          let ch = d
          break
        else
          let s:live = 0
        endif
      else
        let s:live = 1
      endif
    elseif c == "\<Left>"
      let opts['stl'] = 1
      let opts['lm']  = 0
    elseif c == "\<Right>"
      let opts['stl'] = 0
      let opts['lm']  = 1
    elseif c == "\<Down>"
      let opts['lm']  = 0
      let opts['rm']  = 0
    elseif c == "\<Up>"
      silent! call remove(opts, 'stl')
      silent! call remove(opts, 'lm')
      silent! call remove(opts, 'rm')
    elseif ch == "\<C-A>" || ch == "\<C-O>"
      let modes = tolower(s:input("Alignment ([lrc...][[*]*]): ", get(opts, 'a', mode), a:vis))
      if match(modes, '^[lrc]\+\*\{0,2}$') != -1
        let opts['a'] = modes
        let mode      = modes[0]
        while mode != s:shift(a:modes, 1)
        endwhile
      else
        silent! call remove(opts, 'a')
      endif
    elseif ch == "\<C-_>" || ch == "\<C-X>"
      if s:live && regx && !empty(d)
        break
      endif

      let prompt = 'Regular expression: '
      let ch = s:input(prompt, '', a:vis)
      if !empty(ch) && s:valid_regexp(ch)
        let regx = 1
        let d = ch
        if !s:live | break | endif
      else
        let warn = 'Invalid regular expression: '.ch
      endif
    elseif ch == "\<C-F>"
      let f = s:input("Filter (g/../ or v/../): ", get(opts, 'f', ''), a:vis)
      let m = matchlist(f, '^[gv]/\(.\{-}\)/\?$')
      if empty(f)
        silent! call remove(opts, 'f')
      elseif !empty(m) && s:valid_regexp(m[1])
        let opts['f'] = f
      else
        let warn = 'Invalid filter expression'
      endif
    elseif ch =~ '[[:print:]]'
      let check = 1
    else
      let warn = 'Invalid character'
    endif

    if check
      if empty(d)
        if has_key(a:rules, ch)
          let d = ch
          if !s:live
            if a:vis
              execute "normal! gv\<esc>"
            endif
            break
          endif
        else
          let warn = 'Unknown delimiter key: '.ch
        endif
      else
        if regx
          let warn = 'Press <CTRL-X> to finish'
        else
          if d == ch
            break
          else
            let warn = 'Press '''.d.''' again to finish'
          endif
        end
      endif
    endif
  endwhile
  if s:live
    let copts = call('s:summarize', output.summarize)
    let s:live = 0
    let g:easy_align_last_command = s:echon('', n, regx, d, copts, '')
    let s:live = 1
  end
  return [mode, n, ch, opts, regx]
endfunction

function! s:valid_regexp(regexp)
  try
    call matchlist('', a:regexp)
  catch
    return 0
  endtry
  return 1
endfunction

function! s:test_regexp(regexp)
  let regexp = empty(a:regexp) ? @/ : a:regexp
  if !s:valid_regexp(regexp)
    call s:exit('Invalid regular expression: '. regexp)
  endif
  return regexp
endfunction

let s:shorthand_regex =
  \ '\s*\%('
  \   .'\(lm\?[0-9]\+\)\|\(rm\?[0-9]\+\)\|\(iu[01]\)\|\(\%(s\%(tl\)\?[01]\)\|[<>]\)\|'
  \   .'\(da\?[clr]\)\|\(\%(ms\?\|a\)[lrc*]\+\)\|\(i\%(dt\)\?[kdsn]\)\|\([gv]/.*/\)\|\(ig\[.*\]\)'
  \ .'\)\+\s*$'

function! s:parse_shorthand_opts(expr)
  let opts = {}
  let expr = substitute(a:expr, '\s', '', 'g')
  let regex = '^'. s:shorthand_regex

  if empty(expr)
    return opts
  elseif expr !~ regex
    call s:exit("Invalid expression: ". a:expr)
  else
    let match = matchlist(expr, regex)
    for m in filter(match[ 1 : -1 ], '!empty(v:val)')
      for key in ['lm', 'rm', 'l', 'r', 'stl', 's', '<', '>', 'iu', 'da', 'd', 'ms', 'm', 'ig', 'i', 'g', 'v', 'a']
        if stridx(tolower(m), key) == 0
          let rest = strpart(m, len(key))
          if key == 'i' | let key = 'idt' | endif
          if key == 'g' || key == 'v'
            let rest = key.rest
            let key = 'f'
          endif

          if key == 'idt' || index(['d', 'f', 'm', 'a'], key[0]) >= 0
            let opts[key] = rest
          elseif key == 'ig'
            try
              let arr = eval(rest)
              if type(arr) == 3
                let opts[key] = arr
              else
                throw 'Not an array'
              endif
            catch
              call s:exit("Invalid ignore_groups: ". a:expr)
            endtry
          elseif key =~ '[<>]'
            let opts['stl'] = key == '<'
          else
            let opts[key] = str2nr(rest)
          endif
          break
        endif
      endfor
    endfor
  endif
  return s:normalize_options(opts)
endfunction

function! s:parse_args(args)
  if empty(a:args)
    return ['', '', {}, 0]
  endif
  let n    = ''
  let ch   = ''
  let args = a:args
  let cand = ''
  let opts = {}

  " Poor man's option parser
  let idx = 0
  while 1
    let midx = match(args, '\s*{.*}\s*$', idx)
    if midx == -1 | break | endif

    let cand = strpart(args, midx)
    try
      let [l, r, c, k, s, d, n] = ['l', 'r', 'c', 'k', 's', 'd', 'n']
      let [L, R, C, K, S, D, N] = ['l', 'r', 'c', 'k', 's', 'd', 'n']
      let o = eval(cand)
      if type(o) == 4
        let opts = o
        if args[midx - 1 : midx] == '\ '
          let midx += 1
        endif
        let args = strpart(args, 0, midx)
        break
      endif
    catch
      " Ignore
    endtry
    let idx = midx + 1
  endwhile

  " Invalid option dictionary
  if len(substitute(cand, '\s', '', 'g')) > 2 && empty(opts)
    call s:exit("Invalid option: ". cand)
  else
    let opts = s:normalize_options(opts)
  endif

  " Shorthand option notation
  let sopts = matchstr(args, s:shorthand_regex)
  if !empty(sopts)
    let args = strpart(args, 0, len(args) - len(sopts))
    let opts = extend(s:parse_shorthand_opts(sopts), opts)
  endif

  " Has /Regexp/?
  let matches = matchlist(args, '^\(.\{-}\)\s*/\(.*\)/\s*$')

  " Found regexp
  if !empty(matches)
    return [matches[1], s:test_regexp(matches[2]), opts, 1]
  else
    let tokens = matchlist(args, '^\([1-9][0-9]*\|-[0-9]*\|\*\*\?\)\?\s*\(.\{-}\)\?$')
    " Try swapping n and ch
    let [n, ch] = empty(tokens[2]) ? reverse(tokens[1:2]) : tokens[1:2]

    " Resolving command-line ambiguity
    " '\ ' => ' '
    " '\'  => ' '
    if ch =~ '^\\\s*$'
      let ch = ' '
    " '\\' => '\'
    elseif ch =~ '^\\\\\s*$'
      let ch = '\'
    endif

    return [n, ch, opts, 0]
  endif
endfunction

function! s:parse_filter(f)
  let m = matchlist(a:f, '^\([gv]\)/\(.\{-}\)/\?$')
  if empty(m)
    return [0, '']
  else
    return [m[1] == 'g' ? 1 : -1, m[2]]
  endif
endfunction

function! s:interactive_modes(bang)
  return get(g:,
    \ (a:bang ? 'easy_align_bang_interactive_modes' : 'easy_align_interactive_modes'),
    \ (a:bang ? ['r', 'l', 'c'] : ['l', 'r', 'c']))
endfunction

function! s:alternating_modes(mode)
  return a:mode ==? 'r' ? 'rl' : 'lr'
endfunction

function! s:update_lines(todo)
  for [line, content] in items(a:todo)
    call setline(line, s:rtrim(content))
  endfor
endfunction

function! s:parse_nth(n)
  let n = a:n
  let recur = 0
  if n == '*'      | let [nth, recur] = [1, 1]
  elseif n == '**' | let [nth, recur] = [1, 2]
  elseif n == '-'  | let nth = -1
  elseif empty(n)  | let nth = 1
  elseif n == '0' || ( n != '-0' && n != string(str2nr(n)) )
    call s:exit('Invalid N-th parameter: '. n)
  else
    let nth = n
  endif
  return [nth, recur]
endfunction

function! s:build_dict(delimiters, ch, regexp, opts)
  if a:regexp
    let dict = { 'pattern': a:ch }
  else
    if !has_key(a:delimiters, a:ch)
      call s:exit('Unknown delimiter key: '. a:ch)
    endif
    let dict = copy(a:delimiters[a:ch])
  endif
  call extend(dict, a:opts)

  let ml = get(dict, 'left_margin', ' ')
  let mr = get(dict, 'right_margin', ' ')
  if type(ml) == 0 | let ml = repeat(' ', ml) | endif
  if type(mr) == 0 | let mr = repeat(' ', mr) | endif
  call extend(dict, { 'ml': ml, 'mr': mr })

  let dict.pattern = get(dict, 'pattern', a:ch)
  let dict.delimiter_align =
    \ get(dict, 'delimiter_align', get(g:, 'easy_align_delimiter_align', 'r'))[0]
  let dict.indentation =
    \ get(dict, 'indentation', get(g:, 'easy_align_indentation', 'k'))[0]
  let dict.stick_to_left =
    \ get(dict, 'stick_to_left', 0)
  let dict.ignore_unmatched =
    \ get(dict, 'ignore_unmatched', get(g:, 'easy_align_ignore_unmatched', 2))
  let dict.ignore_groups =
    \ get(dict, 'ignore_groups', get(dict, 'ignores', s:ignored_syntax()))
  let dict.filter =
    \ get(dict, 'filter', '')
  return dict
endfunction

function! s:build_mode_sequence(expr, recur)
  let [expr, recur] = [a:expr, a:recur]
  let suffix = matchstr(a:expr, '\*\+$')
  if suffix == '*'
    let expr = expr[0 : -2]
    let recur = 1
  elseif suffix == '**'
    let expr = expr[0 : -3]
    let recur = 2
  endif
  return [tolower(expr), recur]
endfunction

function! s:process(range, mode, n, ch, opts, regexp, rules, bvis)
  let [nth, recur] = s:parse_nth((empty(a:n) && exists('g:easy_align_nth')) ? g:easy_align_nth : a:n)
  let dict = s:build_dict(a:rules, a:ch, a:regexp, a:opts)
  let [mode_sequence, recur] = s:build_mode_sequence(
    \ get(dict, 'align', recur == 2 ? s:alternating_modes(a:mode) : a:mode),
    \ recur)

  let ve = &virtualedit
  set ve=all
  let args = [
    \ {}, split(mode_sequence, '\zs'),
    \ {}, {}, a:range[0], a:range[1],
    \ a:bvis             ? min([virtcol("'<"), virtcol("'>")]) : 1,
    \ (!recur && a:bvis) ? max([virtcol("'<"), virtcol("'>")]) : 0,
    \ nth, recur, dict ]
  let &ve = ve
  while len(args) > 1
    let args = call('s:do_align', args)
  endwhile

  " todo: lines to update
  " summarize: arguments to s:summarize
  return { 'todo': args[0], 'summarize': [ a:opts, recur, mode_sequence ] }
endfunction

function s:summarize(opts, recur, mode_sequence)
  let copts = s:compact_options(a:opts)
  let nbmode = s:interactive_modes(0)[0]
  if !has_key(copts, 'a') && (
    \  (a:recur == 2 && s:alternating_modes(nbmode) != a:mode_sequence) ||
    \  (a:recur != 2 && (a:mode_sequence[0] != nbmode || len(a:mode_sequence) > 1))
    \ )
    call extend(copts, { 'a': a:mode_sequence })
  endif
  return copts
endfunction

function! s:align(bang, live, visualmode, first_line, last_line, expr)
  " Heuristically determine if the user was in visual mode
  if a:visualmode == 'command'
    let vis  = a:first_line == line("'<") && a:last_line == line("'>")
    let bvis = vis && visualmode() == "\<C-V>"
  elseif empty(a:visualmode)
    let vis  = 0
    let bvis = 0
  else
    let vis  = 1
    let bvis = a:visualmode == "\<C-V>"
  end
  let range = [a:first_line, a:last_line]
  let modes = s:interactive_modes(a:bang)
  let mode  = modes[0]
  let s:live = a:live

  let rules = s:easy_align_delimiters_default
  if exists('g:easy_align_delimiters')
    let rules = extend(copy(rules), g:easy_align_delimiters)
  endif

  let [n, ch, opts, regexp] = s:parse_args(a:expr)

  let bypass_fold = get(g:, 'easy_align_bypass_fold', 0)
  let ofm = &l:foldmethod
  try
    if bypass_fold | let &l:foldmethod = 'manual' | endif

    if empty(n) && empty(ch) || s:live
      let [mode, n, ch, opts, regexp] = s:interactive(range, copy(modes), n, ch, opts, rules, vis, bvis)
    endif

    if !s:live
      let output = s:process(range, mode, n, ch, s:normalize_options(opts), regexp, rules, bvis)
      call s:update_lines(output.todo)
      let copts = call('s:summarize', output.summarize)
      let g:easy_align_last_command = s:echon('', n, regexp, ch, copts, '')
    endif
  finally
    if bypass_fold | let &l:foldmethod = ofm | endif
  endtry
endfunction

function! easy_align#align(bang, live, visualmode, expr) range
  try
    call s:align(a:bang, a:live, a:visualmode, a:firstline, a:lastline, a:expr)
  catch /^\%(Vim:Interrupt\|exit\)$/
    if empty(a:visualmode)
      echon "\r"
      echon "\r"
    else
      normal! gv
    endif
  endtry
endfunction

let &cpo = s:cpo_save
unlet s:cpo_save

./doc/easy_align.txt	[[[1
891
*easy-align.txt*	easy-align	Last change: December 14 2014
EASY-ALIGN - TABLE OF CONTENTS             *easyalign* *easy-align* *easy-align-toc*
==============================================================================

  vim-easy-align
    Demo                                                    |easy-align-1|
    Features                                                |easy-align-2|
    Installation                                            |easy-align-3|
    TLDR - One-minute guide                                 |easy-align-4|
    Usage                                                   |easy-align-5|
      Concept of alignment rule                             |easy-align-5-1|
      Execution models                                      |easy-align-5-2|
        1. Using <Plug> mappings                            |easy-align-5-2-1|
        2. Using :EasyAlign command                         |easy-align-5-2-2|
      Interactive mode                                      |easy-align-5-3|
        Predefined alignment rules                          |easy-align-5-3-1|
        Examples                                            |easy-align-5-3-2|
        Using regular expressions                           |easy-align-5-3-3|
        Alignment options in interactive mode               |easy-align-5-3-4|
      Live interactive mode                                 |easy-align-5-4|
      Non-interactive mode                                  |easy-align-5-5|
      Partial alignment in blockwise-visual mode            |easy-align-5-6|
    Alignment options                                       |easy-align-6|
      List of options                                       |easy-align-6-1|
      Filtering lines                                       |easy-align-6-2|
        Examples                                            |easy-align-6-2-1|
      Ignoring delimiters in comments or strings            |easy-align-6-3|
      Ignoring unmatched lines                              |easy-align-6-4|
      Aligning delimiters of different lengths              |easy-align-6-5|
      Adjusting indentation                                 |easy-align-6-6|
      Alignments over multiple occurrences of delimiters    |easy-align-6-7|
      Extending alignment rules                             |easy-align-6-8|
        Examples                                            |easy-align-6-8-1|
    Other options                                           |easy-align-7|
      Disabling &foldmethod during alignment                |easy-align-7-1|
      Left/right/center mode switch in interactive mode     |easy-align-7-2|
    Advanced examples and use cases                         |easy-align-8|
    Related work                                            |easy-align-9|
    Author                                                  |easy-align-10|
    License                                                 |easy-align-11|


VIM-EASY-ALIGN                                                  *vim-easy-align*
==============================================================================

A simple, easy-to-use Vim alignment plugin.


                                                                  *easy-align-1*
DEMO                                                           *easy-align-demo*
==============================================================================

Screencast:
https://raw.githubusercontent.com/junegunn/i/master/vim-easy-align.gif

(Too fast? Slower GIF is {here}{1})

{1} https://raw.githubusercontent.com/junegunn/i/master/vim-easy-align-slow.gif


                                                                  *easy-align-2*
FEATURES                                                   *easy-align-features*
==============================================================================

 - Easy to use
   - Comes with a predefined set of alignment rules
   - Provides a fast and intuitive interface
 - Extensible
   - You can define your own rules
   - Supports arbitrary regular expressions
 - Optimized for code editing
   - Takes advantage of syntax highlighting feature to avoid unwanted
     alignments


                                                                  *easy-align-3*
INSTALLATION                                           *easy-align-installation*
==============================================================================

Use your favorite plugin manager.

Using {vim-plug}{2}:
>
    Plug 'junegunn/vim-easy-align'
<
                                      {2} https://github.com/junegunn/vim-plug


                                                                  *easy-align-4*
TLDR - ONE-MINUTE GUIDE                       *easy-align-tldr-one-minute-guide*
==============================================================================

Add the following mappings to your .vimrc.

                                                             *<Plug>(EasyAlign)*
>
    " Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
    vmap <Enter> <Plug>(EasyAlign)

    " Start interactive EasyAlign for a motion/text object (e.g. gaip)
    nmap ga <Plug>(EasyAlign)
<
And with the following lines of text,
>
    apple   =red
    grass+=green
    sky-=   blue
<
try these commands:

 - vip<Enter>=
   - `v`isual-select `i`nner `p`aragraph
   - Start EasyAlign command (<Enter>)
   - Align around `=`
 - `gaip=`
   - Start EasyAlign command (`ga`) for `i`nner `p`aragraph
   - Align around `=`

Notice that the commands are repeatable with `.` key if you have installed
{repeat.vim}{3}. Install {visualrepeat}{4} as well if you want to repeat in
visual mode.

                               {3} https://github.com/tpope/vim-repeat
                               {4} https://github.com/vim-scripts/visualrepeat


                                                                  *easy-align-5*
USAGE                                                         *easy-align-usage*
==============================================================================


< Concept of alignment rule >_________________________________________________~
                                          *easy-align-concept-of-alignment-rule*
                                                                *easy-align-5-1*

Though easy-align can align lines of text around any delimiter, it provides
shortcuts for the most common use cases with the concept of "alignment rule".

An alignment rule is a predefined set of options for common alignment tasks,
which is identified by a single character, DELIMITER KEY, such as <Space>,
`=`, `:`, `.`, `|`, `&`, `#`, and `,`.

Think of it as a shortcut. Instead of writing regular expression and setting
several options, you can just type in a single character.


< Execution models >__________________________________________________________~
                                                   *easy-align-execution-models*
                                                                *easy-align-5-2*

There are two ways to use easy-align.


1. Using <Plug> mappings~
                                              *easy-align-1-using-plug-mappings*
                                                              *easy-align-5-2-1*

The recommended method is to use <Plug> mappings as described earlier.

                                                         *<Plug>(LiveEasyAlign)*

 ----------------------+--------+-----------------------------------------------------
 Mapping               | Mode   | Description                                         ~
 ----------------------+--------+-----------------------------------------------------
 <Plug>(EasyAlign)     | normal | Start interactive mode for a motion/text object
 <Plug>(EasyAlign)     | visual | Start interactive mode for the selection
 <Plug>(LiveEasyAlign) | normal | Start live-interactive mode for a motion/text object
 <Plug>(LiveEasyAlign) | visual | Start live-interactive mode for the selection
 ----------------------+--------+-----------------------------------------------------


2. Using :EasyAlign command~
                                          *easy-align-2-using-easyalign-command*
                                                              *easy-align-5-2-2*

                                                                    *:EasyAlign*

If you prefer command-line or do not want to start interactive mode, you can
use `:EasyAlign` command instead.

                                                                *:LiveEasyAlign*

 -------------------------------------------+-----------------------------------------------
 Mode                                       | Command                                       ~
 -------------------------------------------+-----------------------------------------------
 Interactive mode                           |  `:EasyAlign[!] [OPTIONS]`
 Live interactive mode                      |  `:LiveEasyAlign[!] [...]`
 Non-interactive mode (predefined rules)    |  `:EasyAlign[!] [N-th] DELIMITER_KEY [OPTIONS]`
 Non-interactive mode (regular expressions) |  `:EasyAlign[!] [N-th] /REGEXP/ [OPTIONS]`
 -------------------------------------------+-----------------------------------------------


< Interactive mode >__________________________________________________________~
                                                   *easy-align-interactive-mode*
                                                                *easy-align-5-3*

The following sections will assume that you have <Plug>(EasyAlign) mappings in
your .vimrc as below:
>
    " Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
    vmap <Enter> <Plug>(EasyAlign)

    " Start interactive EasyAlign for a motion/text object (e.g. gaip)
    nmap ga <Plug>(EasyAlign)
<
With these mappings, you can align text with only a few keystrokes.

 1. <Enter> key in visual mode, or `ga` followed by a motion or a text object to
    start interactive mode
 2. Optional: Enter keys to select alignment mode (left, right, or center)
 3. Optional: N-th delimiter (default: 1)
   - `1` Around the 1st occurrences of delimiters
   - `2` Around the 2nd occurrences of delimiters
   - ...
   - `*` Around all occurrences of delimiters
   - `**` Left-right alternating alignment around all delimiters
   - `-` Around the last occurrences of delimiters (`-1`)
   - `-2` Around the second to last occurrences of delimiters
   - ...
 4. Delimiter key (a single keystroke; <Space>, `=`, `:`, `.`, `|`, `&`, `#`, `,`)


Predefined alignment rules~
                                         *easy-align-predefined-alignment-rules*
                                                              *easy-align-5-3-1*

 --------------+--------------------------------------------------------------------
 Delimiter key | Description/Use cases                                              ~
 --------------+--------------------------------------------------------------------
 <Space>       | General alignment around whitespaces
  `=`            | Operators containing equals sign ( `=` ,  `==,`  `!=` ,  `+=` ,  `&&=` , ...)
  `:`            | Suitable for formatting JSON or YAML
  `.`            | Multi-line method chaining
  `,`            | Multi-line method arguments
  `&`            | LaTeX tables (matches  `&`  and  `\\` )
  `#`            | Ruby/Python comments
  `"`            | Vim comments
 <Bar>         | Table markdown
 --------------+--------------------------------------------------------------------

                                                       *g:easy_align_delimiters*

You can override these default rules or define your own rules with
`g:easy_align_delimiters`, which will be described in {the later section}{5}.

      {5} https://github.com/junegunn/vim-easy-align#extending-alignment-rules


Examples~
                                                           *easy-align-examples*
                                                              *easy-align-5-3-2*

 ------------------+------------------------------------+--------------------
 With visual map   | Description                        | Equivalent command ~
 ------------------+------------------------------------+--------------------
 <Enter><Space>    | Around 1st whitespaces             | :'<,'>EasyAlign\
 <Enter>2<Space>   | Around 2nd whitespaces             | :'<,'>EasyAlign2\
 <Enter>-<Space>   | Around the last whitespaces        | :'<,'>EasyAlign-\
 <Enter>-2<Space>  | Around the 2nd to last whitespaces | :'<,'>EasyAlign-2\
 <Enter>:          | Around 1st colon ( `key:  value` )   | :'<,'>EasyAlign:
 <Enter><Right>:   | Around 1st colon ( `key : value` )   | :'<,'>EasyAlign:<l1
 <Enter>=          | Around 1st operators with =        | :'<,'>EasyAlign=
 <Enter>3=         | Around 3rd operators with =        | :'<,'>EasyAlign3=
 <Enter>*=         | Around all operators with =        | :'<,'>EasyAlign*=
 <Enter>**=        | Left-right alternating around =    | :'<,'>EasyAlign**=
 <Enter><Enter>=   | Right alignment around 1st =       | :'<,'>EasyAlign!=
 <Enter><Enter>**= | Right-left alternating around =    | :'<,'>EasyAlign!**=
 ------------------+------------------------------------+--------------------


Using regular expressions~
                                          *easy-align-using-regular-expressions*
                                                              *easy-align-5-3-3*

Instead of finishing the command with a predefined delimiter key, you can type
in a regular expression after CTRL-/ or CTRL-X key. For example, if you want
to align text around all occurrences of numbers:

 - <Enter>
 - `*`
 - CTRL-X
   - `[0-9]\+`


Alignment options in interactive mode~
                              *easy-align-alignment-options-in-interactive-mode*
                                                              *easy-align-5-3-4*

While in interactive mode, you can set alignment options using special
shortcut keys listed below. The meaning of each option will be described in
{the following sections}{6}.

 --------+--------------------+---------------------------------------------------
 Key     | Option             | Values                                            ~
 --------+--------------------+---------------------------------------------------
 CTRL-F  |  `filter`            | Input string ( `[gv]/.*/?` )
 CTRL-I  |  `indentation`       | shallow, deep, none, keep
 CTRL-L  |  `left_margin`       | Input number or string
 CTRL-R  |  `right_margin`      | Input number or string
 CTRL-D  |  `delimiter_align`   | left, center, right
 CTRL-U  |  `ignore_unmatched`  | 0, 1
 CTRL-G  |  `ignore_groups`     | [], ["String'], ["Comment'], ["String', "Comment']
 CTRL-A  |  `align`             | Input string ( `/[lrc]+\*{0,2}/` )
 <Left>  |  `stick_to_left`     |  `{ 'stick_to_left': 1, 'left_margin': 0 }`
 <Right> |  `stick_to_left`     |  `{ 'stick_to_left': 0, 'left_margin': 1 }`
 <Down>  |  `*_margin`          |  `{ 'left_margin': 0, 'right_margin': 0 }`
 --------+--------------------+---------------------------------------------------

              {6} https://github.com/junegunn/vim-easy-align#alignment-options


< Live interactive mode >_____________________________________________________~
                                              *easy-align-live-interactive-mode*
                                                                *easy-align-5-4*

If you're performing a complex alignment where multiple options should be
carefully adjusted, try "live interactive mode" where you can preview the
result of the alignment on-the-fly as you type in.

Live interactive mode can be started with either <Plug>(LiveEasyAlign) map or
`:LiveEasyAlign` command. Or you can switch to live interactive mode while in
ordinary interactive mode by pressing CTRL-P. (P for Preview)

In live interactive mode, you have to type in the same delimiter (or CTRL-X on
regular expression) again to finalize the alignment. This allows you to
preview the result of the alignment and freely change the delimiter using
backspace key without leaving the interactive mode.


< Non-interactive mode >______________________________________________________~
                                               *easy-align-non-interactive-mode*
                                                                *easy-align-5-5*

Instead of starting interactive mode, you can use declarative, non-interactive
`:EasyAlign` command.
>
    " Using predefined alignment rules
    "   :EasyAlign[!] [N-th] DELIMITER_KEY [OPTIONS]
    :EasyAlign :
    :EasyAlign =
    :EasyAlign *=
    :EasyAlign 3\

    " Using arbitrary regular expressions
    "   :EasyAlign[!] [N-th] /REGEXP/ [OPTIONS]
    :EasyAlign /[:;]\+/
    :EasyAlign 2/[:;]\+/
    :EasyAlign */[:;]\+/
    :EasyAlign **/[:;]\+/
<
A command can end with alignment options, {each of which will be discussed in
detail later}{6}, in Vim dictionary format.

 - `:EasyAlign * /[:;]\+/ { 'stick_to_left': 1, 'left_margin': 0 }`

`stick_to_left` of 1 means that the matched delimiter should be positioned
right next to the preceding token, and `left_margin` of 0 removes the margin
on the left. So we get:
>
    apple;: banana::   cake
    data;;  exchange:; format
<
Option names are fuzzy-matched, so you can write as follows:

 - `:EasyAlign * /[:;]\+/ { 'stl': 1, 'l': 0 }`

You can even omit spaces between the arguments, so concisely (or cryptically):

 - `:EasyAlign*/[:;]\+/{'s':1,'l':0}`

Nice. But let's make it even shorter. Option values can be written in
shorthand notation.

 - `:EasyAlign*/[:;]\+/<l0`

The following table summarizes the shorthand notation.

 -------------------+-----------
 Option             | Expression~
 -------------------+-----------
  `filter`            |  `[gv]/.*/`
  `left_margin`       |  `l[0-9]+`
  `right_margin`      |  `r[0-9]+`
  `stick_to_left`     |  `<`  or  `>`
  `ignore_unmatched`  |  `iu[01]`
  `ignore_groups`     |  `ig\[.*\]`
  `align`             |  `a[lrc*]*`
  `delimiter_align`   |  `d[lrc]`
  `indentation`       |  `i[ksdn]`
 -------------------+-----------

For your information, the same operation can be done in interactive mode as
follows:

 - <Enter>
 - `*`
 - <Left>
 - CTRL-X
   - `[:;]\+`

              {6} https://github.com/junegunn/vim-easy-align#alignment-options


< Partial alignment in blockwise-visual mode >________________________________~
                         *easy-align-partial-alignment-in-blockwise-visual-mode*
                                                                *easy-align-5-6*

In blockwise-visual mode (CTRL-V), EasyAlign command aligns only the selected
text in the block, instead of the whole lines in the range.

Consider the following case where you want to align text around `=>`
operators.
>
    my_hash = { :a => 1,
                :aa => 2,
                :aaa => 3 }
<
In non-blockwise visual mode (`v` / `V`), <Enter>= won't work since the
assignment operator in the first line gets in the way. So we instead enter
blockwise-visual mode (CTRL-V), and select the text around`=>` operators, then
press <Enter>=.
>
    my_hash = { :a   => 1,
                :aa  => 2,
                :aaa => 3 }
<
However, in this case, we don't really need blockwise visual mode since the
same can be easily done using the negative N-th parameter: <Enter>-=


                                                                  *easy-align-6*
ALIGNMENT OPTIONS                                 *easy-align-alignment-options*
==============================================================================


< List of options >___________________________________________________________~
                                                    *easy-align-list-of-options*
                                                                *easy-align-6-1*

 -------------------+---------+-----------------------+--------------------------------------------------------
 Option             | Type    | Default               | Description                                            ~
 -------------------+---------+-----------------------+--------------------------------------------------------
  `filter`            | string  |                       | Line filtering expression:  `g/../`  or  `v/../`
  `left_margin`       | number  | 1                     | Number of spaces to attach before delimiter
  `left_margin`       | string  |  `' '`                  | String to attach before delimiter
  `right_margin`      | number  | 1                     | Number of spaces to attach after delimiter
  `right_margin`      | string  |  `' '`                  | String to attach after delimiter
  `stick_to_left`     | boolean | 0                     | Whether to position delimiter on the left-side
  `ignore_groups`     | list    | ["String', "Comment'] | Delimiters in these syntax highlight groups are ignored
  `ignore_unmatched`  | boolean | 1                     | Whether to ignore lines without matching delimiter
  `indentation`       | string  |  `k`                    | Indentation method (keep, deep, shallow, none)
  `delimiter_align`   | string  |  `r`                    | Determines how to align delimiters of different lengths
  `align`             | string  |  `l`                    | Alignment modes for multiple occurrences of delimiters
 -------------------+---------+-----------------------+--------------------------------------------------------

There are 4 ways to set alignment options (from lowest precedence to highest):

 1. Some option values can be set with corresponding global variables
 2. Option values can be specified in the definition of each alignment rule
 3. Option values can be given as arguments to `:EasyAlign` command
 4. Option values can be set in interactive mode using special shortcut keys

                      *g:easy_align_ignore_groups* *g:easy_align_ignore_unmatched*
                         *g:easy_align_indentation* *g:easy_align_delimiter_align*

 -------------------+-----------------+-------------+--------------------------------
 Option name        | Shortcut key    | Abbreviated | Global variable                ~
 -------------------+-----------------+-------------+--------------------------------
  `filter`            | CTRL-F          |  `[gv]/.*/`   |
  `left_margin`       | CTRL-L          |  `l[0-9]+`    |
  `right_margin`      | CTRL-R          |  `r[0-9]+`    |
  `stick_to_left`     | <Left>, <Right> |  `<`  or  `>`   |
  `ignore_groups`     | CTRL-G          |  `ig\[.*\]`   |  `g:easy_align_ignore_groups`
  `ignore_unmatched`  | CTRL-U          |  `iu[01]`     |  `g:easy_align_ignore_unmatched`
  `indentation`       | CTRL-I          |  `i[ksdn]`    |  `g:easy_align_indentation`
  `delimiter_align`   | CTRL-D          |  `d[lrc]`     |  `g:easy_align_delimiter_align`
  `align`             | CTRL-A          |  `a[lrc*]*`   |
 -------------------+-----------------+-------------+--------------------------------


< Filtering lines >___________________________________________________________~
                                                    *easy-align-filtering-lines*
                                                                *easy-align-6-2*

With `filter` option, you can align lines that only match or do not match a
given pattern. There are several ways to set the pattern.

 1. Press CTRL-F in interactive mode and type in `g/pat/` or `v/pat/`
 2. In command-line, it can be written in dictionary format: `{'filter':
    'g/pat/'}`
 3. Or in shorthand notation: `g/pat/` or `v/pat/`

(You don't need to escape "/'s in the regular expression)


Examples~

                                                              *easy-align-6-2-1*
>
    " Start interactive mode with filter option set to g/hello/
    EasyAlign g/hello/

    " Start live interactive mode with filter option set to v/goodbye/
    LiveEasyAlign v/goodbye/

    " Align the lines with 'hi' around the first colons
    EasyAlign:g/hi/
<

< Ignoring delimiters in comments or strings >________________________________~
                         *easy-align-ignoring-delimiters-in-comments-or-strings*
                                                                *easy-align-6-3*

EasyAlign can be configured to ignore delimiters in certain syntax highlight
groups, such as code comments or strings. By default, delimiters that are
highlighted as code comments or strings are ignored.
>
    " Default:
    "   If a delimiter is in a highlight group whose name matches
    "   any of the followings, it will be ignored.
    let g:easy_align_ignore_groups = ['Comment', 'String']
<
For example, the following paragraph
>
    {
      # Quantity of apples: 1
      apple: 1,
      # Quantity of bananas: 2
      bananas: 2,
      # Quantity of grape:fruits: 3
      'grape:fruits': 3
    }
<
becomes as follows on <Enter>: (or `:EasyAlign:`)
>
    {
      # Quantity of apples: 1
      apple:          1,
      # Quantity of bananas: 2
      bananas:        2,
      # Quantity of grape:fruits: 3
      'grape:fruits': 3
    }
<
Naturally, this feature only works when syntax highlighting is enabled.

You can change the default rule by using one of these 4 methods.

 1. Press CTRL-G in interactive mode to switch groups
 2. Define global `g:easy_align_ignore_groups` list
 3. Define a custom rule in `g:easy_align_delimiters` with `ignore_groups` option
 4. Provide `ignore_groups` option to `:EasyAlign` command. e.g. `:EasyAlign:ig[]`

For example if you set `ignore_groups` option to be an empty list, you get
>
    {
      # Quantity of apples:  1
      apple:                 1,
      # Quantity of bananas: 2
      bananas:               2,
      # Quantity of grape:   fruits: 3
      'grape:                fruits': 3
    }
<
If a pattern in `ignore_groups` is prepended by a `!`, it will have the
opposite meaning. For instance, if `ignore_groups` is given as `['!Comment']`,
delimiters that are not highlighted as Comment will be ignored during the
alignment.


< Ignoring unmatched lines >__________________________________________________~
                                           *easy-align-ignoring-unmatched-lines*
                                                                *easy-align-6-4*

`ignore_unmatched` option determines how EasyAlign command processes lines
that do not have N-th delimiter.

 1. In left-alignment mode, they are ignored
 2. In right or center-alignment mode, they are not ignored, and the last tokens
    from those lines are aligned as well as if there is an invisible trailing
    delimiter at the end of each line
 3. If `ignore_unmatched` is 1, they are ignored regardless of the alignment mode
 4. If `ignore_unmatched` is 0, they are not ignored regardless of the mode

Let's take an example. When we align the following code block around the (1st)
colons,
>
    {
      apple: proc {
        this_line_does_not_have_a_colon
      },
      bananas: 2,
      grapefruits: 3
    }
<
this is usually what we want.
>
    {
      apple:       proc {
        this_line_does_not_have_a_colon
      },
      bananas:     2,
      grapefruits: 3
    }
<
However, we can override this default behavior by setting `ignore_unmatched`
option to zero using one of the following methods.

 1. Press CTRL-U in interactive mode to toggle `ignore_unmatched` option
 2. Set the global `g:easy_align_ignore_unmatched` variable to 0
 3. Define a custom alignment rule with `ignore_unmatched` option set to 0
 4. Provide `ignore_unmatched` option to `:EasyAlign` command. e.g.
    `:EasyAlign:iu0`

Then we get,
>
    {
      apple:                             proc {
        this_line_does_not_have_a_colon
      },
      bananas:                           2,
      grapefruits:                       3
    }
<

< Aligning delimiters of different lengths >__________________________________~
                           *easy-align-aligning-delimiters-of-different-lengths*
                                                                *easy-align-6-5*

Global `g:easy_align_delimiter_align` option and rule-wise/command-wise
`delimiter_align` option determines how matched delimiters of different
lengths are aligned.
>
    apple = 1
    banana += apple
    cake ||= banana
<
By default, delimiters are right-aligned as follows.
>
    apple    = 1
    banana  += apple
    cake   ||= banana
<
However, with `:EasyAlign=dl`, delimiters are left-aligned.
>
    apple  =   1
    banana +=  apple
    cake   ||= banana
<
And on `:EasyAlign=dc`, center-aligned.
>
    apple   =  1
    banana +=  apple
    cake   ||= banana
<
In interactive mode, you can change the option value with CTRL-D key.


< Adjusting indentation >_____________________________________________________~
                                              *easy-align-adjusting-indentation*
                                                                *easy-align-6-6*

By default :EasyAlign command keeps the original indentation of the lines. But
then again we have `indentation` option. See the following example.
>
    # Lines with different indentation
      apple = 1
        banana = 2
          cake = 3
            daisy = 4
         eggplant = 5

    # Default: _k_eep the original indentation
    #   :EasyAlign=
      apple       = 1
        banana    = 2
          cake    = 3
            daisy = 4
         eggplant = 5

    # Use the _s_hallowest indentation among the lines
    #   :EasyAlign=is
      apple    = 1
      banana   = 2
      cake     = 3
      daisy    = 4
      eggplant = 5

    # Use the _d_eepest indentation among the lines
    #   :EasyAlign=id
            apple    = 1
            banana   = 2
            cake     = 3
            daisy    = 4
            eggplant = 5

    # Indentation: _n_one
    #   :EasyAlign=in
    apple    = 1
    banana   = 2
    cake     = 3
    daisy    = 4
    eggplant = 5
<
In interactive mode, you can change the option value with CTRL-I key.


< Alignments over multiple occurrences of delimiters >________________________~
                 *easy-align-alignments-over-multiple-occurrences-of-delimiters*
                                                                *easy-align-6-7*

As stated above, "N-th" parameter is used to target specific occurrences of
the delimiter when it appears multiple times in each line.

To recap:
>
    " Left-alignment around the FIRST occurrences of delimiters
    :EasyAlign =

    " Left-alignment around the SECOND occurrences of delimiters
    :EasyAlign 2=

    " Left-alignment around the LAST occurrences of delimiters
    :EasyAlign -=

    " Left-alignment around ALL occurrences of delimiters
    :EasyAlign *=

    " Left-right ALTERNATING alignment around all occurrences of delimiters
    :EasyAlign **=

    " Right-left ALTERNATING alignment around all occurrences of delimiters
    :EasyAlign! **=
<
In addition to these, you can fine-tune alignments over multiple occurrences
of the delimiters with "align' option. (The option can also be set in
interactive mode with the special key CTRL-A)
>
    " Left alignment over the first two occurrences of delimiters
    :EasyAlign = { 'align': 'll' }

    " Right, left, center alignment over the 1st to 3rd occurrences of delimiters
    :EasyAlign = { 'a': 'rlc' }

    " Using shorthand notation
    :EasyAlign = arlc

    " Right, left, center alignment over the 2nd to 4th occurrences of delimiters
    :EasyAlign 2=arlc

    " (*) Repeating alignments (default: l, r, or c)
    "   Right, left, center, center, center, center, ...
    :EasyAlign *=arlc

    " (**) Alternating alignments (default: lr or rl)
    "   Right, left, center, right, left, center, ...
    :EasyAlign **=arlc

    " Right, left, center, center, center, ... repeating alignment
    " over the 3rd to the last occurrences of delimiters
    :EasyAlign 3=arlc*

    " Right, left, center, right, left, center, ... alternating alignment
    " over the 3rd to the last occurrences of delimiters
    :EasyAlign 3=arlc**
<

< Extending alignment rules >_________________________________________________~
                                          *easy-align-extending-alignment-rules*
                                                                *easy-align-6-8*

Although the default rules should cover the most of the use cases, you can
extend the rules by setting a dictionary named `g:easy_align_delimiters`.

You may refer to the definitions of the default alignment rules {here}{7}.

{7} https://github.com/junegunn/vim-easy-align/blob/2.9.6/autoload/easy_align.vim#L32-L46


Examples~

                                                              *easy-align-6-8-1*
>
    let g:easy_align_delimiters = {
    \ '>': { 'pattern': '>>\|=>\|>' },
    \ '/': {
    \     'pattern':         '//\+\|/\*\|\*/',
    \     'delimiter_align': 'l',
    \     'ignore_groups':   ['!Comment'] },
    \ ']': {
    \     'pattern':       '[[\]]',
    \     'left_margin':   0,
    \     'right_margin':  0,
    \     'stick_to_left': 0
    \   },
    \ ')': {
    \     'pattern':       '[()]',
    \     'left_margin':   0,
    \     'right_margin':  0,
    \     'stick_to_left': 0
    \   },
    \ 'd': {
    \     'pattern':      ' \(\S\+\s*[;=]\)\@=',
    \     'left_margin':  0,
    \     'right_margin': 0
    \   }
    \ }
<

                                                                  *easy-align-7*
OTHER OPTIONS                                         *easy-align-other-options*
==============================================================================


< Disabling &foldmethod during alignment >____________________________________~
                              *easy-align-disabling-foldmethod-during-alignment*
                                                                *easy-align-7-1*

                                                      *g:easy_align_bypass_fold*

{It is reported}{8} that 'foldmethod' value of `expr` or `syntax` can
significantly slow down the alignment when editing a large, complex file with
many folds. To alleviate this issue, EasyAlign provides an option to
temporarily set 'foldmethod' to `manual` during the alignment task. In order
to enable this feature, set `g:easy_align_bypass_fold` switch to 1.
>
    let g:easy_align_bypass_fold = 1
<
                      {8} https://github.com/junegunn/vim-easy-align/issues/14


< Left/right/center mode switch in interactive mode >_________________________~
                  *easy-align-left-right-center-mode-switch-in-interactive-mode*
                                                                *easy-align-7-2*

In interactive mode, you can choose the alignment mode you want by pressing
enter keys. The non-bang command, `:EasyAlign` starts in left-alignment mode
and changes to right and center mode as you press enter keys, while the bang
version first starts in right-alignment mode.

 - `:EasyAlign`
   - Left, Right, Center
 - `:EasyAlign!`
   - Right, Left, Center

If you do not prefer this default mode transition, you can define your own
settings as follows.

            *g:easy_align_interactive_modes* *g:easy_align_bang_interactive_modes*
>
    let g:easy_align_interactive_modes = ['l', 'r']
    let g:easy_align_bang_interactive_modes = ['c', 'r']
<

                                                                  *easy-align-8*
ADVANCED EXAMPLES AND USE CASES     *easy-align-advanced-examples-and-use-cases*
==============================================================================

See {EXAMPLES.md}{9} for more examples.

        {9} https://github.com/junegunn/vim-easy-align/blob/master/EXAMPLES.md


                                                                  *easy-align-9*
RELATED WORK                                           *easy-align-related-work*
==============================================================================

 - {DrChip's Alignment Tool for Vim}{10}
 - {Tabular}{11}

                           {10} http://www.drchip.org/astronaut/vim/align.html
                           {11} https://github.com/godlygeek/tabular


                                                                 *easy-align-10*
AUTHOR                                                       *easy-align-author*
==============================================================================

{Junegunn Choi}{12}

                                              {12} https://github.com/junegunn


                                                                 *easy-align-11*
LICENSE                                                     *easy-align-license*
==============================================================================

MIT

==============================================================================
vim:tw=78:sw=2:ts=2:ft=help:norl:nowrap:
./plugin/easy_align.vim	[[[1
142
" Copyright (c) 2014 Junegunn Choi
"
" MIT License
"
" Permission is hereby granted, free of charge, to any person obtaining
" a copy of this software and associated documentation files (the
" "Software"), to deal in the Software without restriction, including
" without limitation the rights to use, copy, modify, merge, publish,
" distribute, sublicense, and/or sell copies of the Software, and to
" permit persons to whom the Software is furnished to do so, subject to
" the following conditions:
"
" The above copyright notice and this permission notice shall be
" included in all copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
" EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
" MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
" NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
" LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
" OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
" WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

if exists("g:loaded_easy_align_plugin")
  finish
endif
let g:loaded_easy_align_plugin = 1

command! -nargs=* -range -bang EasyAlign <line1>,<line2>call easy_align#align(<bang>0, 0, 'command', <q-args>)
command! -nargs=* -range -bang LiveEasyAlign <line1>,<line2>call easy_align#align(<bang>0, 1, 'command', <q-args>)

let s:last_command = 'EasyAlign'

function! s:abs(v)
  return a:v >= 0 ? a:v : - a:v
endfunction

function! s:remember_visual(mode)
  let s:last_visual = [a:mode, s:abs(line("'>") - line("'<")), s:abs(col("'>") - col("'<"))]
endfunction

function! s:repeat_visual()
  let [mode, ldiff, cdiff] = s:last_visual
  let cmd = 'normal! '.mode
  if ldiff > 0
    let cmd .= ldiff . 'j'
  endif

  let ve_save = &virtualedit
  try
    if mode == "\<C-V>"
      if cdiff > 0
        let cmd .= cdiff . 'l'
      endif
      set virtualedit+=block
    endif
    execute cmd.":\<C-r>=g:easy_align_last_command\<Enter>\<Enter>"
    call s:set_repeat()
  finally
    if ve_save != &virtualedit
      let &virtualedit = ve_save
    endif
  endtry
endfunction

function! s:repeat_in_visual()
  if exists('g:easy_align_last_command')
    call s:remember_visual(visualmode())
    call s:repeat_visual()
  endif
endfunction

function! s:set_repeat()
  silent! call repeat#set("\<Plug>(EasyAlignRepeat)")
endfunction

function! s:generic_easy_align_op(type, vmode, live)
  if !&modifiable
    if a:vmode
      normal! gv
    endif
    return
  endif
  let sel_save = &selection
  let &selection = "inclusive"

  if a:vmode
    let vmode = a:type
    let [l1, l2] = ["'<", "'>"]
    call s:remember_visual(vmode)
  else
    let vmode = ''
    let [l1, l2] = [line("'["), line("']")]
    unlet! s:last_visual
  endif

  try
    let range = l1.','.l2
    if get(g:, 'easy_align_need_repeat', 0)
      execute range . g:easy_align_last_command
    else
      execute range . "call easy_align#align(0, a:live, vmode, '')"
    end
    call s:set_repeat()
  finally
    let &selection = sel_save
  endtry
endfunction

function! s:easy_align_op(type, ...)
  call s:generic_easy_align_op(a:type, a:0, 0)
endfunction

function! s:live_easy_align_op(type, ...)
  call s:generic_easy_align_op(a:type, a:0, 1)
endfunction

function! s:easy_align_repeat()
  if exists('s:last_visual')
    call s:repeat_visual()
  else
    try
      let g:easy_align_need_repeat = 1
      normal! .
    finally
      unlet! g:easy_align_need_repeat
    endtry
  endif
endfunction

nnoremap <silent> <Plug>(EasyAlign) :set opfunc=<SID>easy_align_op<Enter>g@
vnoremap <silent> <Plug>(EasyAlign) :<C-U>call <SID>easy_align_op(visualmode(), 1)<Enter>
nnoremap <silent> <Plug>(LiveEasyAlign) :set opfunc=<SID>live_easy_align_op<Enter>g@
vnoremap <silent> <Plug>(LiveEasyAlign) :<C-U>call <SID>live_easy_align_op(visualmode(), 1)<Enter>

" vim-repeat support
nnoremap <silent> <Plug>(EasyAlignRepeat) :call <SID>easy_align_repeat()<Enter>
vnoremap <silent> <Plug>(EasyAlignRepeat) :<C-U>call <SID>repeat_in_visual()<Enter>

" Backward-compatibility (deprecated)
nnoremap <silent> <Plug>(EasyAlignOperator) :set opfunc=<SID>easy_align_op<Enter>g@

./test/README.md	[[[1
13
Test cases for vim-easy-align
=============================

### Prerequisite

- [Vader.vim](https://github.com/junegunn/vader.vim)

### Run

```
./run
```

./test/blockwise.vader	[[[1
22
Include: include/setup.vader

Given clojure:
  (def world [[1      1 1 1       1]
              [999 999 999 999 1]
              [1 1 1 1 1]
              [1 999 999 999 999]
              [1 1 1 1 1]])

Do (Recursive alignment in blockwise-visual mode):
  f[;
  \<C-V>G
  \<Enter>*\<Space>

Expect clojure:
  (def world [[1   1   1   1   1]
              [999 999 999 999 1]
              [1   1   1   1   1]
              [1   999 999 999 999]
              [1   1   1   1   1]])

Include: include/teardown.vader
./test/commandline.vader	[[[1
191
Include: include/setup.vader

Given (fruits):
  apple;:;;banana::cake
  data;;exchange:;::format

Execute (regular expression):
  %EasyAlign/[:;]\+/
  AssertEqual ':EasyAlign /[:;]\+/', g:easy_align_last_command

Expect:
  apple ;:;; banana::cake
  data    ;; exchange:;::format

Execute (options dictionary):
  %EasyAlign/[:;]\+/{ 'left_margin': '<', 'right_margin': 3 }

Expect:
  apple<;:;;   banana::cake
  data <  ;;   exchange:;::format

Execute (fuzzy matching):
  %EasyAlign/[:;]\+/{ 'l':'<', 'r': '>'}

Expect:
  apple<;:;;>banana::cake
  data <  ;;>exchange:;::format

Execute (shorthand notation of margin):
  %EasyAlign/[:;]\+/l0r0

Expect:
  apple;:;;banana::cake
  data   ;;exchange:;::format

Execute (delimiter align):
  %EasyAlign*/[:;]\+/l0r0dc

Expect:
  apple;:;;banana   :: cake
  data  ;; exchange:;::format

Execute (DEPRECATED: shorthand notation of mode_sequence and margin):
  %EasyAlign/[:;]\+/mrc*l2r2

Expect:
  apple  ;:;;   banana     ::   cake
   data    ;;  exchange  :;::  format

Execute (shorthand notation of align and margin):
  %EasyAlign/[:;]\+/arc*l2r2

Expect:
  apple  ;:;;   banana     ::   cake
   data    ;;  exchange  :;::  format

Execute (DEPRECATED: deep indentation):
  %EasyAlign/[:;]\+/mrc*l2r2
  %EasyAlign*/[:;]\+/idmrl*

Expect:
   apple ;:;; banana     :: cake
    data   ;; exchange :;:: format

Execute (deep indentation):
  %EasyAlign/[:;]\+/arc*l2r2
  %EasyAlign*/[:;]\+/idarl*

Expect:
   apple ;:;; banana     :: cake
    data   ;; exchange :;:: format

Execute (stick_to_left):
  %EasyAlign*/[:;]\+/stl1l0dlrm3

Expect:
  apple;:;;   banana::       cake
  data;;      exchange:;::   format

Execute (<):
  %EasyAlign*/[:;]\+/<l0dlrm3

Expect:
  apple;:;;   banana::       cake
  data;;      exchange:;::   format

Execute (>):
  %EasyAlign*/[:;]\+/l0dl<>rm3

Expect:
  apple;:;;   banana  ::     cake
  data ;;     exchange:;::   format

Execute (different regular expression):
  %EasyAlign*/../{'lm':'<','rm':'>'}

Expect:
  ap><pl><e;><:;><;b><an><an><a:><:c><ak>e
  da><ta><;;><ex><ch><an><ge><:;><::><fo><rm><at

Execute (merge different option notations):
  %EasyAlign*/../iu0 { 'l': '<', 'r': '>' }

Expect:
  ap><pl><e;><:;><;b><an><an><a:><:c><ak>e
  da><ta><;;><ex><ch><an><ge><:;><::><fo> <rm><at

Execute (Use current search pattern as delimiter if empty regular expression is given):
  /an
  %EasyAlign*//

Expect:
  apple;:;;b an  an a::cake
  data;;exch an ge:;::format

Given javascript (json):
  var jdbc = {
    // JDBC driver for MySQL database:
    driver: "com.mysql.jdbc.Driver",
    /* JDBC URL for the connection (jdbc:mysql://HOSTNAME/DATABASE) */
    url: 'jdbc:mysql://localhost/test',
    database: "test",
    "user:pass":"r00t:pa55"
  };

Execute (default syntax-aware alignment):
  %EasyAlign*:

Expect javascript:
  var jdbc = {
    // JDBC driver for MySQL database:
    driver:      "com.mysql.jdbc.Driver",
    /* JDBC URL for the connection (jdbc:mysql://HOSTNAME/DATABASE) */
    url:         'jdbc:mysql://localhost/test',
    database:    "test",
    "user:pass": "r00t:pa55"
  };

Execute (do not ignore unmatched):
  %EasyAlign*:iu0

Expect javascript:
  var jdbc = {
    // JDBC driver for MySQL database:
    driver:                                                             "com.mysql.jdbc.Driver",
    /* JDBC URL for the connection (jdbc:mysql://HOSTNAME/DATABASE) */
    url:                                                                'jdbc:mysql://localhost/test',
    database:                                                           "test",
    "user:pass":                                                        "r00t:pa55"
  };

Execute (do not ignore any group):
  %EasyAlign*:ig[]iu0

Expect javascript:
  var jdbc = {
    // JDBC driver for MySQL database:
    driver:                               "com.mysql.jdbc.Driver",
    /* JDBC URL for the connection (jdbc: mysql:                    //HOSTNAME/DATABASE) */
    url:                                  'jdbc:                    mysql:                   //localhost/test',
    database:                             "test",
    "user:                                pass":                    "r00t:                   pa55"
  };

Execute (ignore only strings):
  %EasyAlign*:ig['String']

Expect javascript:
  var jdbc = {
    // JDBC driver for MySQL database:
    driver:                               "com.mysql.jdbc.Driver",
    /* JDBC URL for the connection (jdbc: mysql: //HOSTNAME/DATABASE) */
    url:                                  'jdbc:mysql://localhost/test',
    database:                             "test",
    "user:pass":                          "r00t:pa55"
  };

Execute (ignore only comments):
  %EasyAlign*:ig['Comment']

Expect javascript:
  var jdbc = {
    // JDBC driver for MySQL database:
    driver:   "com.mysql.jdbc.Driver",
    /* JDBC URL for the connection (jdbc:mysql://HOSTNAME/DATABASE) */
    url:      'jdbc: mysql: //localhost/test',
    database: "test",
    "user:    pass": "r00t: pa55"
  };

Include: include/teardown.vader
./test/extra.vader	[[[1
13
Include: include/setup.vader

Before:
  set nomodifiable
After:
  set modifiable
  AssertEqual "hello\nworld\n", @"
Given:
  hello
  world
Do (#43 Do nothing when nomodifiable):
  vip\<enter>\<enter>\<enter>y

./test/fixed.vader	[[[1
263
Include: include/setup.vader

Given (Table):
  |a|b|c|d|
  | -|-|>-|-|
  |aaa|bbb|ccc|ddd|

Do (Partial alignment around 1st |):
  \<C-V>ljj\<Enter>|

Expect (Right margin should be correctly attached):
  | a|b|c|d|
  | -|-|>-|-|
  | aaa|bbb|ccc|ddd|

Given (empty buffer):

Execute (Aligning lines with many delimiters should not fail):
  call visualmode(1)
  call setline(1, repeat('|', &maxfuncdepth + 1))
  %EasyAlign*|
  AssertEqual (&maxfuncdepth + 1) * 3 - 2, len(getline(1))

Given:
  a  | b | c
  aa | bb | cc

Execute:
  %EasyAlign*|iu0{'l':'<', 'r': '>'}

Expect:
  a <|>b <|>c
  aa<|>bb<|>cc

Given (Trailing delimiter):
  a  | b | c |
  aa | bb | cc |

Execute:
  %EasyAlign*|iu0{'l':'<', 'r': '>'}

Expect:
  a <|>b <|>c <|
  aa<|>bb<|>cc<|

Given (Tab-indented code (#20)):
  class MyUnitTest(unittest.TestCase):
  	def test_base(self):
  		n2f = {}
  		n2v = {}
  		f2v = {}
  		n2gv = {}
  		n2vt = {}

Execute:
  set tabstop=1
  %EasyAlign=

Expect:
  class MyUnitTest(unittest.TestCase):
  	def test_base(self):
  		n2f  = {}
  		n2v  = {}
  		f2v  = {}
  		n2gv = {}
  		n2vt = {}

Execute:
  set tabstop=2
  %EasyAlign=

Expect:
  class MyUnitTest(unittest.TestCase):
  	def test_base(self):
  		n2f  = {}
  		n2v  = {}
  		f2v  = {}
  		n2gv = {}
  		n2vt = {}

Execute:
  set tabstop=4
  %EasyAlign=

Expect:
  class MyUnitTest(unittest.TestCase):
  	def test_base(self):
  		n2f  = {}
  		n2v  = {}
  		f2v  = {}
  		n2gv = {}
  		n2vt = {}

Execute:
  set tabstop=8
  %EasyAlign=

Expect:
  class MyUnitTest(unittest.TestCase):
  	def test_base(self):
  		n2f  = {}
  		n2v  = {}
  		f2v  = {}
  		n2gv = {}
  		n2vt = {}

Execute:
  set tabstop=12
  %EasyAlign=

Expect:
  class MyUnitTest(unittest.TestCase):
  	def test_base(self):
  		n2f  = {}
  		n2v  = {}
  		f2v  = {}
  		n2gv = {}
  		n2vt = {}

Given (Tab-indented code (#20)):
  class MyUnitTest(unittest.TestCase):
  	def test_base(self):
  	# 	n2f= {}
  	## 	n2v= {}
  	# 	f2v = {}
  	## 	n2gv  = {}
  	# 	n2vt   = {}

Execute:
  set tabstop=12
  %EasyAlign=

Expect:
  class MyUnitTest(unittest.TestCase):
  	def test_base(self):
  	# 	n2f  = {}
  	## 	n2v  = {}
  	# 	f2v  = {}
  	## 	n2gv = {}
  	# 	n2vt = {}

Given (Some text):
  a,b,c

  d,e,f

Do (Select 1st line, align 3rd line):
- First line
  V\<esc>
- Last line
  G
- Align
  \<space>Aip*,
- Previous selection
  gv
- Upcase
  U

Expect:
  A,B,C

  d, e, f

Given c (#40 Ignored delimiters in LiveEasyAlign causes spurious undo):
  printf("foo = %f\n", foo);
  printf("foobar = %f\n", foobar);

Do:
  gUiw
  :%LiveEasyAlign\<enter>
  =\<bs>==

Expect c:
  PRINTF("foo = %f\n", foo);
  printf("foobar = %f\n", foobar);

* #50 Error when using delimiter alignment option
Given:
  a|bbb|c
  aa|bb|cc

Do (#50 EasyAlign command with 'a' option):
  :%EasyAlign {'a': 'l'}\<cr>
  \<cr>
  *|

Expect (Some text):
   a | bbb |  c
  aa |  bb | cc

* #51 Repeat of visual <Plug>(LiveEasyAlign) broken
Do (#51/#52 <Plug>(EasyAlignRepeat) in visual mode):
  V\<space>\<enter>\<enter>*||
  G
  V\<space>.

Expect:
  a | bbb | c
  aa | bb | cc

* #65 ?=
Given:
  a?=b
  aa-=bb
  aaa?=bbb

Do (#65 Alignment around ?=):
  \<space>Aip=

Expect:
  a   ?= b
  aa  -= bb
  aaa ?= bbb

* #67 \v
Given c:
  bzero(&servaddr, sizeof(servaddr));
  servaddr.sin_family = AF_INET;
  servaddr.sin_addr.s_addr = htonl(INADDR_ANY);
  servaddr.sin_port = htons(SERV_PORT);

Execute (#67 \v breaks surrounding regex):
  %EasyAlign/\v(\=\s)@<=</

Expect:
  bzero(&servaddr, sizeof(servaddr));
  servaddr.sin_family =       AF_INET;
  servaddr.sin_addr.s_addr =  htonl(INADDR_ANY);
  servaddr.sin_port =         htons(SERV_PORT);

Execute (#67 \V followed by \v shouldn't matter):
  %EasyAlign/\v(\=\s)@<=<\V/

Expect:
  bzero(&servaddr, sizeof(servaddr));
  servaddr.sin_family =       AF_INET;
  servaddr.sin_addr.s_addr =  htonl(INADDR_ANY);
  servaddr.sin_port =         htons(SERV_PORT);

Execute (#67 \zs is now allowed):
  %EasyAlign/=\zs/

Expect:
  bzero(&servaddr, sizeof(servaddr));
  servaddr.sin_family =       AF_INET;
  servaddr.sin_addr.s_addr =  htonl(INADDR_ANY);
  servaddr.sin_port =         htons(SERV_PORT);

Include: include/teardown.vader

Given:
  hello = world bye all
  hello world = bye all
  hello world = foo all

Do (#105: Incorrectly detection of blockwise visual mode):
  \<c-v>jj\<esc>
  \<Space>Aip=

Expect:
  hello       = world bye all
  hello world = bye all
  hello world = foo all
./test/fixme.vader	[[[1
24
Include: include/setup.vader

# It is currently possible that EasyAlign command incorrectly judges
# that it was executed in block-wise visual mode
Given:
  a|b|c

Do (FIXME invalid judgement - block-wise visual mode):
  \<C-V>\<Esc>
  :%EasyAlign|\<CR>

Expect:
  a | b | c

Do (TODO Workaround: reset visualmode() on error):
  \<C-V>\<Esc>
  :%EasyAlign|\<CR>
  :%EasyAlign|\<CR>

Expect:
  a | b | c

Include: include/teardown.vader

./test/include/setup.vader	[[[1
38
Execute (Clean up test environment):
  Save g:easy_align_ignore_groups,     g:easy_align_ignore_unmatched
  Save g:easy_align_indentation,       g:easy_align_delimiter_align
  Save g:easy_align_interactive_modes, g:easy_align_bang_interactive_modes
  Save g:easy_align_delimiters,        g:easy_align_bypass_fold
  Save &tabstop, mapleader

  unlet! g:easy_align_ignore_groups
  unlet! g:easy_align_ignore_unmatched
  unlet! g:easy_align_indentation
  unlet! g:easy_align_delimiter_align
  unlet! g:easy_align_interactive_modes
  unlet! g:easy_align_bang_interactive_modes
  unlet! g:easy_align_bypass_fold

  let g:easy_align_delimiters = {}
  let mapleader = ' '
  vnoremap <silent> r<Enter>         :EasyAlign!<Enter>
  vnoremap <silent> <Leader>r<Enter> :LiveEasyAlign!<Enter>

  " " Legacy
  " vnoremap <silent> <Enter>          :EasyAlign<Enter>
  " vnoremap <silent> <Leader><Enter>  :LiveEasyAlign<Enter>
  " nmap <leader>A <Plug>(EasyAlignOperator)

  set ts=2

  vmap <Enter>         <Plug>(EasyAlign)
  vmap <leader><Enter> <Plug>(LiveEasyAlign)
  nmap <leader>A       <Plug>(EasyAlign)
  vmap <leader>.       <Plug>(EasyAlignRepeat)

  silent! call plug#load('vim-easy-align')

Before:
After:
Given:

./test/include/teardown.vader	[[[1
4
Given:
Execute (Restoring test environment):
  Restore

./test/interactive.vader	[[[1
1886
Include: include/setup.vader

###########################################################

Given (space-separated columns):
  1 22222 33 444 555 6666 7 888
  11 222 3333 4 55 6666 77 888
  111 22 333 444 55555 6666 7 88888
  1111 2 33 444 555 66 777 8

Do (left-align):
  vip
  \<Enter>
  *\<Space>

Expect:
  1    22222 33   444 555   6666 7   888
  11   222   3333 4   55    6666 77  888
  111  22    333  444 55555 6666 7   88888
  1111 2     33   444 555   66   777 8

Do (left-align / cursor position retained):
  vGww
  \<Enter>
  *\<Space>D

Expect:
  1    22222 33   444 555   6666 7   888
  11   222   3333 4   55    6666 77  888
  111  22    333  444 55555 6666 7   88888
  1111 2 

Do (left-align using operator map):
  \<Space>Aip*\<Space>

Expect:
  1    22222 33   444 555   6666 7   888
  11   222   3333 4   55    6666 77  888
  111  22    333  444 55555 6666 7   88888
  1111 2     33   444 555   66   777 8

Do (right-align):
  vip
  \<Enter>\<Enter>
  *\<Space>

Expect:
     1 22222   33 444   555 6666   7   888
    11   222 3333   4    55 6666  77   888
   111    22  333 444 55555 6666   7 88888
  1111     2   33 444   555   66 777     8

Do (center-align):
  vip
  \<Enter>\<Enter>\<Enter>
  *\<Space>

Expect:
   1   22222  33  444  555  6666  7   888
   11   222  3333  4   55   6666 77   888
  111   22   333  444 55555 6666  7  88888
  1111   2    33  444  555   66  777   8

Given (comma-separated columns):
  a,,bbb
  aa,,bb
  aaa,,b
  aaaa,,
  aaa,b,
  aa,bb,
  a,bbb,

Do (left-align):
  vip
  \<Enter>
  *,

Expect:
  a,    ,    bbb
  aa,   ,    bb
  aaa,  ,    b
  aaaa, ,
  aaa,  b,
  aa,   bb,
  a,    bbb,

Do (right-align):
  vip
  \<Enter>\<Enter>
  *,

Expect:
     a,    , bbb
    aa,    ,  bb
   aaa,    ,   b
  aaaa,    ,
   aaa,   b,
    aa,  bb,
     a, bbb,

Do (center-align):
  vip
  \<Enter>\<Enter>\<Enter>
  *,

Expect:
   a,    ,   bbb
   aa,   ,   bb
  aaa,   ,    b
  aaaa,  ,
  aaa,   b,
   aa,  bb,
   a,   bbb,

###########################################################

Given (the beatles):
  Paul McCartney 1942
  George Harrison 1943mmdd
  Ringo Starr 1940mm
  Pete Best 1941

Do (around first space):
  vip
  \<Enter>
  \<Space>

Expect:
  Paul   McCartney 1942
  George Harrison 1943mmdd
  Ringo  Starr 1940mm
  Pete   Best 1941

Do (around second space):
  vip
  \<Enter>
  2\<Space>

Expect:
  Paul McCartney  1942
  George Harrison 1943mmdd
  Ringo Starr     1940mm
  Pete Best       1941

Do (around all spaces):
  vip
  \<Enter>
  *\<Space>

Expect:
  Paul   McCartney 1942
  George Harrison  1943mmdd
  Ringo  Starr     1940mm
  Pete   Best      1941

Do (right-align around all spaces):
  vip
  \<Enter>\<Enter>
  *\<Space>

Expect:
    Paul McCartney     1942
  George  Harrison 1943mmdd
   Ringo     Starr   1940mm
    Pete      Best     1941

Do (center-align around all spaces):
  vip
  \<Enter>\<Enter>\<Enter>
  *\<Space>

Expect:
   Paul  McCartney   1942
  George Harrison  1943mmdd
  Ringo    Starr    1940mm
   Pete    Best      1941

Do (center-align around the last space):
  vip
  \<Enter>\<Enter>\<Enter>
  -\<Space>

Expect:
  Paul  McCartney 1942
  George Harrison 1943mmdd
  Ringo   Starr   1940mm
  Pete     Best   1941

Do (right-align around second space):
  vip
  \<Enter>\<Enter>
  2\<Space>

Expect:
  Paul  McCartney 1942
  George Harrison 1943mmdd
  Ringo     Starr 1940mm
  Pete       Best 1941

Do (left-right alternating alignment):
  vip
  \<Enter>
  **\<Space>

Expect:
  Paul   McCartney 1942
  George  Harrison 1943mmdd
  Ringo      Starr 1940mm
  Pete        Best 1941

Do (right-left alternating alignment):
  vip
  \<Enter>\<Enter>
  **\<Space>

Expect:
    Paul McCartney     1942
  George Harrison  1943mmdd
   Ringo Starr       1940mm
    Pete Best          1941

Do (with numeric left/right margin):
  vip
  \<Enter>
  *
  \<C-L>2\<Enter>
  \<Enter>
  \<C-R>5\<Enter>
  *
  \<Space>

Expect:
    Paul        McCartney            1942
  George        Harrison         1943mmdd
   Ringo        Starr              1940mm
    Pete        Best                 1941

Do (with string left/right margin):
  vip
  \<Enter>
  \<C-L>lft\<Enter>
  \<C-R>rgt\<Enter>
  *\<Space>

Expect:
  Paul  lft rgtMcCartneylft rgt1942
  Georgelft rgtHarrison lft rgt1943mmdd
  Ringo lft rgtStarr    lft rgt1940mm
  Pete  lft rgtBest     lft rgt1941

Execute (with regular expression):
  1,4EasyAlign*/../

Expect:
  Pa  ul  Mc  Ca  rt  ne  y   19  42
  Ge  or  ge  Ha  rr  is  on  19  43  mm  dd
  Ri  ng  o   St  ar  r   19  40  mm
  Pe  te  Be  st  19  41

###########################################################

Given ruby (delimiters in comments and strings):
  xyz="abc=def"
  a=b#=c

Do (align around all =):
  vip
  \<Enter>*=

Expect ruby (are not aligned):
  xyz = "abc=def"
  a   = b#=c

###########################################################

Given javascript (json):
  var jdbc = {
    // JDBC driver for MySQL database:
    driver: "com.mysql.jdbc.Driver",
    /* JDBC URL for the connection (jdbc:mysql://HOSTNAME/DATABASE) */
    url: 'jdbc:mysql://localhost/test',
    database: "test",
    "user:pass":"r00t:pa55"
  };

Do (around colons):
  vip\<Enter>*:

Expect javascript:
  var jdbc = {
    // JDBC driver for MySQL database:
    driver:      "com.mysql.jdbc.Driver",
    /* JDBC URL for the connection (jdbc:mysql://HOSTNAME/DATABASE) */
    url:         'jdbc:mysql://localhost/test',
    database:    "test",
    "user:pass": "r00t:pa55"
  };

Do (around colons, do not stick to left):
  vip\<Enter>*\<Right>:

Expect javascript:
  var jdbc = {
    // JDBC driver for MySQL database:
    driver      : "com.mysql.jdbc.Driver",
    /* JDBC URL for the connection (jdbc:mysql://HOSTNAME/DATABASE) */
    url         : 'jdbc:mysql://localhost/test',
    database    : "test",
    "user:pass" : "r00t:pa55"
  };

Do (around first colon, do not ignore comments and strings):
  vip\<Enter>\<C-G>*:

Expect javascript:
  var jdbc = {
    // JDBC driver for MySQL database:
    driver:                               "com.mysql.jdbc.Driver",
    /* JDBC URL for the connection (jdbc: mysql: //HOSTNAME/DATABASE) */
    url:                                  'jdbc: mysql: //localhost/test',
    database:                             "test",
    "user:                                pass": "r00t: pa55"
  };

Do (do not ignore comments and strings, do not ignore unmatched):
  vip\<Enter>\<C-G>\<C-U>*:

Expect javascript:
  var jdbc = {
    // JDBC driver for MySQL database:
    driver:                               "com.mysql.jdbc.Driver",
    /* JDBC URL for the connection (jdbc: mysql:                    //HOSTNAME/DATABASE) */
    url:                                  'jdbc:                    mysql:                   //localhost/test',
    database:                             "test",
    "user:                                pass":                    "r00t:                   pa55"
  };

Execute (set g:easy_align_ignore_groups and g:easy_align_ignore_unmatched):
  let g:easy_align_ignore_unmatched = 0
  let g:easy_align_ignore_groups = []

Do (do not ignore comments and strings, do not ignore unmatched using global vars):
  vip\<Enter>*:

Expect javascript:
  var jdbc = {
    // JDBC driver for MySQL database:
    driver:                               "com.mysql.jdbc.Driver",
    /* JDBC URL for the connection (jdbc: mysql:                    //HOSTNAME/DATABASE) */
    url:                                  'jdbc:                    mysql:                   //localhost/test',
    database:                             "test",
    "user:                                pass":                    "r00t:                   pa55"
  };

Execute (unset g:easy_align_ignore_groups and g:easy_align_ignore_unmatched):
  unlet g:easy_align_ignore_unmatched
  unlet g:easy_align_ignore_groups

###########################################################

Given (table):
  | Option| Type | Default | Description |
  |--|--|--|--|
  | threads | Fixnum | 1 | number of threads in the thread pool |
  |queues |Fixnum | 1 | number of concurrent queues |
  |queue_size | Fixnum | 1000 | size of each queue |
  |   interval | Numeric | 0 | dispatcher interval for batch processing |
  |batch | Boolean | false | enables batch processing mode |
   |batch_size | Fixnum | nil | number of maximum items to be assigned at once |
   |logger | Logger | nil | logger instance for debug logs |

Do (around all |):
  vip\<Enter>*|

Expect:
  | Option     | Type    | Default | Description                                    |
  | --         | --      | --      | --                                             |
  | threads    | Fixnum  | 1       | number of threads in the thread pool           |
  | queues     | Fixnum  | 1       | number of concurrent queues                    |
  | queue_size | Fixnum  | 1000    | size of each queue                             |
  | interval   | Numeric | 0       | dispatcher interval for batch processing       |
  | batch      | Boolean | false   | enables batch processing mode                  |
  | batch_size | Fixnum  | nil     | number of maximum items to be assigned at once |
  | logger     | Logger  | nil     | logger instance for debug logs                 |

Do (around all |, and right-align 3rd and center-align the last):
  vip\<Enter>*|
  gv\<Enter>\<Enter>3|
  gv\<Enter>\<Enter>\<Enter>-|

Expect:
  | Option     |    Type | Default |                  Description                   |
  | --         |      -- | --      |                       --                       |
  | threads    |  Fixnum | 1       |      number of threads in the thread pool      |
  | queues     |  Fixnum | 1       |          number of concurrent queues           |
  | queue_size |  Fixnum | 1000    |               size of each queue               |
  | interval   | Numeric | 0       |    dispatcher interval for batch processing    |
  | batch      | Boolean | false   |         enables batch processing mode          |
  | batch_size |  Fixnum | nil     | number of maximum items to be assigned at once |
  | logger     |  Logger | nil     |         logger instance for debug logs         |

Do (Left-right alternating alignment):
  vip\<Enter>**|

Expect:
  |     Option | Type    | Default | Description                                    |
  |         -- | --      |      -- | --                                             |
  |    threads | Fixnum  |       1 | number of threads in the thread pool           |
  |     queues | Fixnum  |       1 | number of concurrent queues                    |
  | queue_size | Fixnum  |    1000 | size of each queue                             |
  |   interval | Numeric |       0 | dispatcher interval for batch processing       |
  |      batch | Boolean |   false | enables batch processing mode                  |
  | batch_size | Fixnum  |     nil | number of maximum items to be assigned at once |
  |     logger | Logger  |     nil | logger instance for debug logs                 |

Do (Right-left alternating alignment):
  vip\<Enter>\<Enter>**|

Expect:
  | Option     |    Type | Default |                                    Description |
  | --         |      -- | --      |                                             -- |
  | threads    |  Fixnum | 1       |           number of threads in the thread pool |
  | queues     |  Fixnum | 1       |                    number of concurrent queues |
  | queue_size |  Fixnum | 1000    |                             size of each queue |
  | interval   | Numeric | 0       |       dispatcher interval for batch processing |
  | batch      | Boolean | false   |                  enables batch processing mode |
  | batch_size |  Fixnum | nil     | number of maximum items to be assigned at once |
  | logger     |  Logger | nil     |                 logger instance for debug logs |

Do (Right-left alternating alignment, indent: deep):
  vip\<Enter>\<Enter>**\<C-I>\<C-I>|

Expect:
    | Option     |    Type | Default |                                    Description |
    | --         |      -- | --      |                                             -- |
    | threads    |  Fixnum | 1       |           number of threads in the thread pool |
    | queues     |  Fixnum | 1       |                    number of concurrent queues |
    | queue_size |  Fixnum | 1000    |                             size of each queue |
    | interval   | Numeric | 0       |       dispatcher interval for batch processing |
    | batch      | Boolean | false   |                  enables batch processing mode |
    | batch_size |  Fixnum | nil     | number of maximum items to be assigned at once |
    | logger     |  Logger | nil     |                 logger instance for debug logs |

# Doesn't work. Why?
# Do (Repeat the last command):
#   :%\<C-R>=g:easy_align_last_command\<Enter>\<Enter>

Execute (Repeat the last command):
  Log g:easy_align_last_command
  execute '%'.g:easy_align_last_command

Expect:
    | Option     |    Type | Default |                                    Description |
    | --         |      -- | --      |                                             -- |
    | threads    |  Fixnum | 1       |           number of threads in the thread pool |
    | queues     |  Fixnum | 1       |                    number of concurrent queues |
    | queue_size |  Fixnum | 1000    |                             size of each queue |
    | interval   | Numeric | 0       |       dispatcher interval for batch processing |
    | batch      | Boolean | false   |                  enables batch processing mode |
    | batch_size |  Fixnum | nil     | number of maximum items to be assigned at once |
    | logger     |  Logger | nil     |                 logger instance for debug logs |

Do (around all | with no margin, right-align 2nd to last):
  vip\<Enter>\<C-L>0\<Enter>\<C-R>0\<Enter>*|
  vip\<Enter>\<Enter>\<C-L>0\<Enter>\<C-R>0\<Enter>-2|

Expect:
  |Option    |Type   |Default|Description                                   |
  |--        |--     |     --|--                                            |
  |threads   |Fixnum |      1|number of threads in the thread pool          |
  |queues    |Fixnum |      1|number of concurrent queues                   |
  |queue_size|Fixnum |   1000|size of each queue                            |
  |interval  |Numeric|      0|dispatcher interval for batch processing      |
  |batch     |Boolean|  false|enables batch processing mode                 |
  |batch_size|Fixnum |    nil|number of maximum items to be assigned at once|
  |logger    |Logger |    nil|logger instance for debug logs                |

Do (live interactive mode):
  vip\<Space>\<Enter>
  |
  \<C-L>(\<Enter>
  \<C-R>)\<Enter>
  ***
  **
  \<BS>\<BS>\<BS>
  **|\<Enter>|

Expect:
  |)Option    (|)   Type(|)Default(|)                                   Description(|
  |)--        (|)     --(|)--     (|)                                            --(|
  |)threads   (|) Fixnum(|)1      (|)          number of threads in the thread pool(|
  |)queues    (|) Fixnum(|)1      (|)                   number of concurrent queues(|
  |)queue_size(|) Fixnum(|)1000   (|)                            size of each queue(|
  |)interval  (|)Numeric(|)0      (|)      dispatcher interval for batch processing(|
  |)batch     (|)Boolean(|)false  (|)                 enables batch processing mode(|
  |)batch_size(|) Fixnum(|)nil    (|)number of maximum items to be assigned at once(|
  |)logger    (|) Logger(|)nil    (|)                logger instance for debug logs(|

Do (Switching to live interactive mode):
  vip\<Enter>
* Switch to live interactive mode
  \<C-P>
  |
  \<C-L><\<Enter>
  \<C-R>>\<Enter>
  ***
  **
  \<BS>\<BS>\<BS>
  **|\<Enter>|

Expect:
  |>Option    <|>   Type<|>Default<|>                                   Description<|
  |>--        <|>     --<|>--     <|>                                            --<|
  |>threads   <|> Fixnum<|>1      <|>          number of threads in the thread pool<|
  |>queues    <|> Fixnum<|>1      <|>                   number of concurrent queues<|
  |>queue_size<|> Fixnum<|>1000   <|>                            size of each queue<|
  |>interval  <|>Numeric<|>0      <|>      dispatcher interval for batch processing<|
  |>batch     <|>Boolean<|>false  <|>                 enables batch processing mode<|
  |>batch_size<|> Fixnum<|>nil    <|>number of maximum items to be assigned at once<|
  |>logger    <|> Logger<|>nil    <|>                logger instance for debug logs<|

Do (Toggling live interactive mode (delimiter entered)):
  vip\<Enter>
* Enable live mode
  \<C-P>
  |*
* Disable live mode
  \<C-P>
  gg2jdG

Expect:
  | Option     | Type    | Default | Description                                    |
  | --         | --      | --      | --                                             |

Do (Toggling live interactive mode (delimiter not entered)):
  vip\<Enter>
* Enable live mode
  \<C-P>
  \<Enter>
* Disable live mode
  \<C-P>
  *|
  gg2jdG

Expect:
  |     Option |    Type | Default |                                    Description |
  |         -- |      -- |      -- |                                             -- |

Do (live interactive mode!):
  vip\<Space>r\<Enter>
  |
  \<C-L>[\<Enter>
  \<C-R>]\<Enter>
  ***
  **
  \<BS>\<BS>\<BS>
  **
  \<C-I>\<C-I>
  \<C-X>|\<Enter>
  \<Enter>
  \<C-X>

Expect:
   [|]    Option[|]Type   [|]Default[|]Description                                   [|
   [|]        --[|]--     [|]     --[|]--                                            [|
   [|]   threads[|]Fixnum [|]      1[|]number of threads in the thread pool          [|
   [|]    queues[|]Fixnum [|]      1[|]number of concurrent queues                   [|
   [|]queue_size[|]Fixnum [|]   1000[|]size of each queue                            [|
   [|]  interval[|]Numeric[|]      0[|]dispatcher interval for batch processing      [|
   [|]     batch[|]Boolean[|]  false[|]enables batch processing mode                 [|
   [|]batch_size[|]Fixnum [|]    nil[|]number of maximum items to be assigned at once[|
   [|]    logger[|]Logger [|]    nil[|]logger instance for debug logs                [|

Execute (g:easy_align_last_command should be set):
  Assert exists('g:easy_align_last_command')
  unlet g:easy_align_last_command

Do:
  vip\<Space>\<Enter>**|\<C-C>

Execute (g:easy_align_last_command should not be set if interrupted):
  Assert !exists('g:easy_align_last_command')

Do (g:easy_align_nth is not set (work with default value 1)):
  vip\<Enter>|

Expect:
  | Option| Type | Default | Description |
  | --|--|--|--|
  | threads | Fixnum | 1 | number of threads in the thread pool |
  | queues |Fixnum | 1 | number of concurrent queues |
  | queue_size | Fixnum | 1000 | size of each queue |
  | interval | Numeric | 0 | dispatcher interval for batch processing |
  | batch | Boolean | false | enables batch processing mode |
  | batch_size | Fixnum | nil | number of maximum items to be assigned at once |
  | logger | Logger | nil | logger instance for debug logs |

Execute (set g:easy_align_nth):
  let g:easy_align_nth = '2'

Do (g:easy_align_nth is set as 2):
  vip\<Enter>|

Expect:
  | Option     | Type | Default | Description |
  |--          | --|--|--|
  | threads    | Fixnum | 1 | number of threads in the thread pool |
  |queues      | Fixnum | 1 | number of concurrent queues |
  |queue_size  | Fixnum | 1000 | size of each queue |
  |   interval | Numeric | 0 | dispatcher interval for batch processing |
  |batch       | Boolean | false | enables batch processing mode |
   |batch_size | Fixnum | nil | number of maximum items to be assigned at once |
   |logger     | Logger | nil | logger instance for debug logs |

Execute (unset g:easy_align_nth):
  unlet g:easy_align_nth

Execute (set g:easy_align_nth):
  let g:easy_align_nth = '*'

Do (g:easy_align_nth is set as *):
  vip\<Enter>|

Expect:
  | Option     | Type    | Default | Description                                    |
  | --         | --      | --      | --                                             |
  | threads    | Fixnum  | 1       | number of threads in the thread pool           |
  | queues     | Fixnum  | 1       | number of concurrent queues                    |
  | queue_size | Fixnum  | 1000    | size of each queue                             |
  | interval   | Numeric | 0       | dispatcher interval for batch processing       |
  | batch      | Boolean | false   | enables batch processing mode                  |
  | batch_size | Fixnum  | nil     | number of maximum items to be assigned at once |
  | logger     | Logger  | nil     | logger instance for debug logs                 |

Execute (unset g:easy_align_nth):
  unlet g:easy_align_nth

Execute (set g:easy_align_nth):
  let g:easy_align_nth = '**'

Do (g:easy_align_nth is set as **):
  vip\<Enter>|

Expect:
  |     Option | Type    | Default | Description                                    |
  |         -- | --      |      -- | --                                             |
  |    threads | Fixnum  |       1 | number of threads in the thread pool           |
  |     queues | Fixnum  |       1 | number of concurrent queues                    |
  | queue_size | Fixnum  |    1000 | size of each queue                             |
  |   interval | Numeric |       0 | dispatcher interval for batch processing       |
  |      batch | Boolean |   false | enables batch processing mode                  |
  | batch_size | Fixnum  |     nil | number of maximum items to be assigned at once |
  |     logger | Logger  |     nil | logger instance for debug logs                 |

Execute (unset g:easy_align_nth):
  unlet g:easy_align_nth

Execute (set g:easy_align_nth):
  let g:easy_align_nth = '-'

Do (g:easy_align_nth is set as -):
  vip\<Enter>|

Expect:
  | Option| Type | Default | Description                                       |
  |--|--|--|--                                                                 |
  | threads | Fixnum | 1 | number of threads in the thread pool                |
  |queues |Fixnum | 1 | number of concurrent queues                            |
  |queue_size | Fixnum | 1000 | size of each queue                             |
  |   interval | Numeric | 0 | dispatcher interval for batch processing        |
  |batch | Boolean | false | enables batch processing mode                     |
   |batch_size | Fixnum | nil | number of maximum items to be assigned at once |
   |logger | Logger | nil | logger instance for debug logs                     |

Execute (unset g:easy_align_nth):
  unlet g:easy_align_nth

Execute (set g:easy_align_nth):
  let g:easy_align_nth = '-2'

Do (g:easy_align_nth is set as -2):
  vip\<Enter>|

Expect:
  | Option| Type | Default    | Description |
  |--|--|--                   | --|
  | threads | Fixnum | 1      | number of threads in the thread pool |
  |queues |Fixnum | 1         | number of concurrent queues |
  |queue_size | Fixnum | 1000 | size of each queue |
  |   interval | Numeric | 0  | dispatcher interval for batch processing |
  |batch | Boolean | false    | enables batch processing mode |
   |batch_size | Fixnum | nil | number of maximum items to be assigned at once |
   |logger | Logger | nil     | logger instance for debug logs |

Execute (unset g:easy_align_nth):
  unlet g:easy_align_nth

###########################################################

Given (comma-separated items):
  aaa,   bb,c
  d,eeeeeee
  fffff, gggggggggg,
  h, ,           ii
  j,,k

Do (around all commas):
  vip\<Enter>*,

Expect:
  aaa,   bb,         c
  d,     eeeeeee
  fffff, gggggggggg,
  h,     ,           ii
  j,     ,           k

Do (around all commas, do not stick to left):
  vip\<Enter>\<Right>*,

Expect:
  aaa   , bb         , c
  d     , eeeeeee
  fffff , gggggggggg ,
  h     ,            , ii
  j     ,            , k

Do (center-align around all commas):
  vip\<Enter>\<Enter>\<Enter>*,

Expect:
   aaa,      bb,     c
    d,    eeeeeee
  fffff, gggggggggg,
    h,        ,      ii
    j,        ,      k

###########################################################

Given ruby (multi-line ruby Hash):
  options = { :caching => nil,
              :versions => 3,
              "cache=blocks" => false }.merge(options)

Do (around the last =):
  vip\<Enter>-=

Expect ruby:
  options = { :caching       => nil,
              :versions      => 3,
              "cache=blocks" => false }.merge(options)

Do (partial alignment):
  f:
  \<C-V>jj3E
  \<Enter>\<Enter>=

Expect ruby:
  options = {       :caching => nil,
                   :versions => 3,
              "cache=blocks" => false }.merge(options)

###########################################################

Given c (C code with comments 1):
  /* a */ b = c
  aa >= bb
  // aaa = bbb = cccc
  /* aaaa = */ bbbb   === cccc   " = dddd = " = eeee
  aaaaa /* bbbbb */      == ccccc /* != eeeee = */ === fffff

Do:
  vip\<Enter>*=

Expect c:
  /* a */ b           = c
  aa                 >= bb
  // aaa = bbb = cccc
  /* aaaa = */ bbbb === cccc   " = dddd = "      = eeee
  aaaaa /* bbbbb */  == ccccc /* != eeeee = */ === fffff

Do:
  vip\<Enter>\<C-G>\<C-U>*=

Expect c:
  /* a */ b          = c
  aa                >= bb
  // aaa             = bbb        = cccc
  /* aaaa            = */ bbbb  === cccc   " = dddd   = "     = eeee
  aaaaa /* bbbbb */ == ccccc /*  != eeeee    = */   === fffff

###########################################################

Given c (C code with comments 2):
  int a = 1;
  long b = 2;
  float c = 3;
  string d = 4;
  // this line should not get aligned
  long int e = 5;
  std::map f;
  std::map g; /* this? */
  short h /* how about this? */ = 6;
  string i = "asdf";

Do (around =):
  vip\<Enter>=

Expect c:
  int a                         = 1;
  long b                        = 2;
  float c                       = 3;
  string d                      = 4;
  // this line should not get aligned
  long int e                    = 5;
  std::map f;
  std::map g; /* this? */
  short h /* how about this? */ = 6;
  string i                      = "asdf";

Do (right-align around =, comment lines are ignored):
  vip\<Enter>\<Enter>=

Expect c:
                          int a = 1;
                         long b = 2;
                        float c = 3;
                       string d = 4;
  // this line should not get aligned
                     long int e = 5;
                    std::map f;
  std::map g; /* this? */
  short h /* how about this? */ = 6;
                       string i = "asdf";

Do (right-align around =, do not ignore comment lines):
  vip\<Enter>\<Enter>\<C-U>=

Expect c:
                                int a = 1;
                               long b = 2;
                              float c = 3;
                             string d = 4;
  // this line should not get aligned
                           long int e = 5;
                          std::map f;
              std::map g; /* this? */
        short h /* how about this? */ = 6;
                             string i = "asdf";

###########################################################

Given ruby (= operators):
  a =
  a = 1
  bbbb .= 2
  ccccccc = 3
  ccccccccccccccc
  ddd = #
  eeee === eee = eee = eee=f
  fff = ggg += gg &&= gg
  g != hhhhhhhh == # 8
  i   := 5
  i     %= 5
  i       *= 5
  j     =~ 5
  j   >= 5
  aa      =>         123
  aa <<= 123
  aa        >>= 123
  bbb               => 123
  c     => 1233123
  d   =>      123
  dddddd &&= 123
  dddddd ||= 123
  dddddd /= 123
  gg <=> ee

Do (1st =):
  vip\<Enter>=

Expect ruby:
  a         =
  a         = 1
  bbbb     .= 2
  ccccccc   = 3
  ccccccccccccccc
  ddd       = #
  eeee    === eee = eee = eee=f
  fff       = ggg += gg &&= gg
  g        != hhhhhhhh == # 8
  i        := 5
  i        %= 5
  i        *= 5
  j        =~ 5
  j        >= 5
  aa       => 123
  aa      <<= 123
  aa      >>= 123
  bbb      => 123
  c        => 1233123
  d        => 123
  dddddd  &&= 123
  dddddd  ||= 123
  dddddd   /= 123
  gg      <=> ee

Do (LR =):
  vip\<Enter>**=

Expect ruby:
  a         =
  a         =        1
  bbbb     .=        2
  ccccccc   =        3
  ccccccccccccccc
  ddd       =        #
  eeee    ===      eee  = eee   = eee = f
  fff       =      ggg += gg  &&=  gg
  g        != hhhhhhhh == # 8
  i        :=        5
  i        %=        5
  i        *=        5
  j        =~        5
  j        >=        5
  aa       =>      123
  aa      <<=      123
  aa      >>=      123
  bbb      =>      123
  c        =>  1233123
  d        =>      123
  dddddd  &&=      123
  dddddd  ||=      123
  dddddd   /=      123
  gg      <=>       ee

Do (DEPRECATED: Alignment using mode_sequence, delimiter_align):
  vip\<Enter>\<C-O>\<Backspace>cr*\<Enter>\<C-D>=

Expect ruby:
         a        =
         a        =          1
       bbbb       .=         2
      ccccccc     =          3
  ccccccccccccccc
        ddd       =          #
       eeee       ===      eee =  eee =   eee = f
        fff       =        ggg +=  gg &&=  gg
         g        !=  hhhhhhhh == # 8
         i        :=         5
         i        %=         5
         i        *=         5
         j        =~         5
         j        >=         5
        aa        =>       123
        aa        <<=      123
        aa        >>=      123
        bbb       =>       123
         c        =>   1233123
         d        =>       123
      dddddd      &&=      123
      dddddd      ||=      123
      dddddd      /=       123
        gg        <=>       ee

Do (Alignment using align, delimiter_align):
  vip\<Enter>\<C-A>\<Backspace>cr*\<Enter>\<C-D>=

Expect ruby:
         a        =
         a        =          1
       bbbb       .=         2
      ccccccc     =          3
  ccccccccccccccc
        ddd       =          #
       eeee       ===      eee =  eee =   eee = f
        fff       =        ggg +=  gg &&=  gg
         g        !=  hhhhhhhh == # 8
         i        :=         5
         i        %=         5
         i        *=         5
         j        =~         5
         j        >=         5
        aa        =>       123
        aa        <<=      123
        aa        >>=      123
        bbb       =>       123
         c        =>   1233123
         d        =>       123
      dddddd      &&=      123
      dddddd      ||=      123
      dddddd      /=       123
        gg        <=>       ee


Do (DEPRECATED: mode_sequence starting from 2nd, delimiter_align = center):
  vip\<Enter>\<C-O>\<Backspace>rc**\<Enter>\<C-D>\<C-D>2=

Expect ruby:
  a =
  a =                    1
  bbbb .=                2
  ccccccc =              3
  ccccccccccccccc
  ddd =                  #
  eeee ===             eee =  eee  =  eee = f
  fff =                ggg += gg  &&=  gg
  g !=            hhhhhhhh == # 8
  i   :=                 5
  i     %=               5
  i       *=             5
  j     =~               5
  j   >=                 5
  aa      =>           123
  aa <<=               123
  aa        >>=        123
  bbb               => 123
  c     =>         1233123
  d   =>               123
  dddddd &&=           123
  dddddd ||=           123
  dddddd /=            123
  gg <=>                ee

Do (align starting from 2nd, delimiter_align = center):
  vip\<Enter>\<C-A>\<Backspace>rc**\<Enter>\<C-D>\<C-D>2=

Expect ruby:
  a =
  a =                    1
  bbbb .=                2
  ccccccc =              3
  ccccccccccccccc
  ddd =                  #
  eeee ===             eee =  eee  =  eee = f
  fff =                ggg += gg  &&=  gg
  g !=            hhhhhhhh == # 8
  i   :=                 5
  i     %=               5
  i       *=             5
  j     =~               5
  j   >=                 5
  aa      =>           123
  aa <<=               123
  aa        >>=        123
  bbb               => 123
  c     =>         1233123
  d   =>               123
  dddddd &&=           123
  dddddd ||=           123
  dddddd /=            123
  gg <=>                ee

Do (around all =s, do not ignore unmatched):
  vip\<Enter>\<C-U>
  \<C-L>0\<Enter>
  \<C-R>0\<Enter>
  \<C-D>\<C-D>
  *=

Expect ruby:
  a               =
  a               = 1
  bbbb           .= 2
  ccccccc         = 3
  ccccccccccccccc
  ddd             = #
  eeee           ===eee     = eee = eee=f
  fff             = ggg     +=gg &&=gg
  g              != hhhhhhhh==# 8
  i              := 5
  i              %= 5
  i              *= 5
  j              =~ 5
  j              >= 5
  aa             => 123
  aa             <<=123
  aa             >>=123
  bbb            => 123
  c              => 1233123
  d              => 123
  dddddd         &&=123
  dddddd         ||=123
  dddddd         /= 123
  gg             <=>ee

Do (Center-align around 2nd =):
  vip\<Enter>\<Enter>\<Enter>2=

Expect ruby:
  a =
  a =                   1
  bbbb .=               2
  ccccccc =             3
  ccccccccccccccc
  ddd =                 #
  eeee ===             eee    = eee = eee=f
  fff =                ggg   += gg &&= gg
  g !=              hhhhhhhh == # 8
  i   :=                5
  i     %=              5
  i       *=            5
  j     =~              5
  j   >=                5
  aa      =>           123
  aa <<=               123
  aa        >>=        123
  bbb               => 123
  c     =>           1233123
  d   =>               123
  dddddd &&=           123
  dddddd ||=           123
  dddddd /=            123
  gg <=>               ee

###########################################################

Given ruby (Trailing ruby line comment):
  apple = 1 # comment not aligned
  apricot = 'DAD' + 'F#AD'
  banana = 'Gros Michel' ## comment 2

Do (around the last spaces):
  vip\<Enter>-\<Space>

Expect ruby:
  apple = 1              # comment not aligned
  apricot = 'DAD' +      'F#AD'
  banana = 'Gros Michel' ## comment 2

Do (using # rule):
  vip\<Enter>\<C-U>#

Expect ruby:
  apple = 1                #  comment not aligned
  apricot = 'DAD' + 'F#AD'
  banana = 'Gros Michel'   ## comment 2

Do (using regular expression):
  vip\<Enter>=
  gv\<Enter>
  \<C-U>\<C-G>\<C-G>
  \<C-D>
  \<C-X>#\+\<Enter>

Expect ruby:
  apple   = 1              #  comment not aligned
  apricot = 'DAD' + 'F#AD'
  banana  = 'Gros Michel'  ## comment 2

###########################################################

Given (method chain):
  my_object
        .method1.chain
      .second_method.call
        .third.call
       .method_4.execute

Do (around all .):
  vip\<Enter>*.

Expect:
  my_object
      .method1      .chain
      .second_method.call
      .third        .call
      .method_4     .execute

Do (around all . with deep indentation):
  vip\<Enter>\<C-I>\<C-I>*.

Expect:
  my_object
        .method1      .chain
        .second_method.call
        .third        .call
        .method_4     .execute

Execute (set g:easy_align_indentation):
  let g:easy_align_indentation = 'd'

Do (around all . with deep indentation):
  vip\<Enter>*.

Expect:
  my_object
        .method1      .chain
        .second_method.call
        .third        .call
        .method_4     .execute

Execute (unset g:easy_align_indentation):
  unlet g:easy_align_indentation

Do (right-align around all .):
  vip\<Enter>\<Enter>*.

Expect:
  my_object
           .      method1.  chain
           .second_method.   call
           .        third.   call
           .     method_4.execute

###########################################################

Execute (define d rule):
  let g:easy_align_delimiters.d =
  \ { 'pattern': '\s\+\(\S\+\s*[;=]\)\@=', 'left_margin': 0, 'right_margin': 0 }

Given c (complex var dec):
  const char* str = "Hello";
  int64_t count = 1 + 2;
  static double pi = 3.14;
  static std::map<std::string, float>* scores =    pointer;

Do (using d rule):
  vip\<Enter>d
  gv\<Enter>=

Expect c:
  const char*                          str    = "Hello";
  int64_t                              count  = 1 + 2;
  static double                        pi     = 3.14;
  static std::map<std::string, float>* scores = pointer;

###########################################################

Given (indented code):
    apple = 1
      banana = 2
        cake = 3
          daisy = 4
       eggplant = 5

Do:
  vip\<Enter>=

Expect:
    apple       = 1
      banana    = 2
        cake    = 3
          daisy = 4
       eggplant = 5

Do (shallow indentation):
  vip\<Enter>\<C-I>=

Expect:
    apple    = 1
    banana   = 2
    cake     = 3
    daisy    = 4
    eggplant = 5

Do (deep indentation):
  vip\<Enter>\<C-I>\<C-I>=

Expect:
          apple    = 1
          banana   = 2
          cake     = 3
          daisy    = 4
          eggplant = 5

Do (no indentation):
  vip\<Enter>\<C-I>\<C-I>\<C-I>=

Expect:
  apple    = 1
  banana   = 2
  cake     = 3
  daisy    = 4
  eggplant = 5

Do (right-align, shallow indentation):
  vip\<Enter>\<Enter>\<C-I>=

Expect:
       apple = 1
      banana = 2
        cake = 3
       daisy = 4
    eggplant = 5

Do (center-align, shallow indentation):
  vip\<Enter>\<Enter>\<Enter>\<C-I>=

Expect:
     apple   = 1
     banana  = 2
      cake   = 3
     daisy   = 4
    eggplant = 5

Do (right-align, deep indentation):
  vip\<Enter>\<Enter>\<C-I>\<C-I>=

Expect:
             apple = 1
            banana = 2
              cake = 3
             daisy = 4
          eggplant = 5

Do (center-align, deep indentation):
  vip\<Enter>\<Enter>\<Enter>\<C-I>\<C-I>=

Expect:
           apple   = 1
           banana  = 2
            cake   = 3
           daisy   = 4
          eggplant = 5

Do (right-align, no indentation):
  vip\<Enter>\<Enter>\<C-I>\<C-I>\<C-I>=

###########################################################

Expect:
     apple = 1
    banana = 2
      cake = 3
     daisy = 4
  eggplant = 5

Given (Center-align cases):
              aaaa = 123456778901234567890 =
  cccccccccccccc = 12345678 =

                aaaa = 123456778901234567890 =
                 bbbbbb = 4
  cccccccccccccccccc = 12345678 =

                      aaaa = 123456778901234567890 =
       cccccccccccccccccc = 12345678 =

                      aaaaa                     = 123456778901234567890 =
                       cc                       = 12345678 =

  aaaaa = 123456778901234567890 =
  bbbbbbbbbb = 12345 =

  aaaaa = 123456778901234567890 =
  cccccccccccccccccc = 123 =

  aaaaa = 123456778901234567890 =
  cccccccccccccccccc = 12345678 =

  aaaaa = 12345 =
  bbbbbbbbbb = 123456778901234567890       =

  aaaaa =             12345
  bbbbbbbbbb = 123456778901234567890

Do:
  vip\<Enter>\<Enter>\<Enter>=
  }jvip\<Enter>\<Enter>\<Enter>=
  }jvip\<Enter>\<Enter>\<Enter>=
  }jvip\<Enter>\<Enter>\<Enter>=
  }jvip\<Enter>\<Enter>\<Enter>2=
  }jvip\<Enter>\<Enter>\<Enter>2=
  }jvip\<Enter>\<Enter>\<Enter>2=
  }jvip\<Enter>\<Enter>\<Enter>2=
  }jvip\<Enter>\<Enter>\<Enter>2=

Expect:
              aaaa      = 123456778901234567890 =
         cccccccccccccc = 12345678 =

                  aaaa        = 123456778901234567890 =
                 bbbbbb       = 4
           cccccccccccccccccc = 12345678 =

                      aaaa        = 123456778901234567890 =
               cccccccccccccccccc = 12345678 =

                      aaaaa = 123456778901234567890 =
                       cc   = 12345678 =

  aaaaa = 123456778901234567890 =
  bbbbbbbbbb =    12345         =

  aaaaa =     123456778901234567890 =
  cccccccccccccccccc = 123          =

  aaaaa =       123456778901234567890 =
  cccccccccccccccccc = 12345678       =

  aaaaa =              12345         =
  bbbbbbbbbb = 123456778901234567890 =

  aaaaa =              12345
  bbbbbbbbbb = 123456778901234567890

###########################################################

Given (long delimiter):
  ...-.-----
  ..--..----
  .---...---
  ----....--
  .---.....-
  ..--......
  ...-.....-

Do:
  vip\<Enter>*\<C-X>-\+\<Enter>

Expect:
  ...    - .     -----
  ..    -- ..     ----
  .    --- ...     ---
      ---- ....     --
  .    --- .....     -
  ..    -- ......
  ...    - .....     -

Do:
  vip\<Enter>*\<C-D>\<C-X>-\+\<Enter>

Expect:
  ... -    .     -----
  ..  --   ..    ----
  .   ---  ...   ---
      ---- ....  --
  .   ---  ..... -
  ..  --   ......
  ... -    ..... -

Do:
  vip\<Enter>*\<C-D>\<C-D>\<C-X>-\+\<Enter>

Expect:
  ...  -   .     -----
  ..   --  ..    ----
  .   ---  ...    ---
      ---- ....   --
  .   ---  .....   -
  ..   --  ......
  ...  -   .....   -

Execute (set g:easy_align_delimiter_align):
  let g:easy_align_delimiter_align = 'c'

Do:
  vip\<Enter>*\<C-X>-\+\<Enter>

Expect:
  ...  -   .     -----
  ..   --  ..    ----
  .   ---  ...    ---
      ---- ....   --
  .   ---  .....   -
  ..   --  ......
  ...  -   .....   -

Execute (unset g:easy_align_delimiter_align):
  unlet g:easy_align_delimiter_align

###########################################################

Execute (set g:easy_align_interactive_modes):
  let g:easy_align_interactive_modes = ['r', 'c']
  let g:easy_align_bang_interactive_modes = ['c', 'l']

Given (Test g:easy_align_interactive_modes):
  a = 1
  bb = 2
  ccc = 3

Do:
  vip\<Enter>=

Expect:
    a = 1
   bb = 2
  ccc = 3

Do:
  vip\<Enter>\<Enter>=

Expect:
   a  = 1
  bb  = 2
  ccc = 3

Do:
  vipr\<Enter>=

Expect:
   a  = 1
  bb  = 2
  ccc = 3

Do:
  vipr\<Enter>\<Enter>=

Expect:
  a   = 1
  bb  = 2
  ccc = 3

Do:
  vipr\<Enter>\<Enter>\<Enter>=

Expect:
   a  = 1
  bb  = 2
  ccc = 3

Execute (unset g:easy_align_interactive_modes):
  unlet g:easy_align_interactive_modes
  unlet g:easy_align_bang_interactive_modes

###########################################################

Given (Test ignore_unmatched behavior):
  a = b = c
  aabba = bbbbb

Do (left-align):
  vip\<Enter>*=

Expect:
  a     = b = c
  aabba = bbbbb

Do (left-align, no ignore_unmatched):
  vip\<Enter>\<C-U>*=

Expect:
  a     = b     = c
  aabba = bbbbb

Do (right-align):
  vip\<Enter>\<Enter>*=

Expect:
      a =     b = c
  aabba = bbbbb

Do (right-align, explicit ignore_unmatched):
  vip\<Enter>\<Enter>\<C-U>\<C-U>*=

Expect:
      a = b = c
  aabba = bbbbb

Do (center-align):
  vip\<Enter>\<Enter>\<Enter>*=

Expect:
    a   =   b   = c
  aabba = bbbbb

Do (center-align):
  vip\<Enter>\<C-U>\<Enter>\<Enter>\<C-U>*=

Expect:
    a   = b = c
  aabba = bbbbb

###########################################################

Given (test filter option):
  aaa=aaa=aaa
  aaaaa=aaaaa=aaaaa
  aaaaaaa=aaaaaaa=aaaaaaab
  bbbbb=bbbbb=bbbbb
  aaa=aaa=aaa

Do (g/a/):
  vip\<Enter>
  \<C-F>g/a/\<Enter>
  *=

Expect:
  aaa     = aaa     = aaa
  aaaaa   = aaaaa   = aaaaa
  aaaaaaa = aaaaaaa = aaaaaaab
  bbbbb=bbbbb=bbbbb
  aaa     = aaa     = aaa

Do (g/a - you can omit the trailing /):
  vip\<Enter>
  \<C-F>g/a\<Enter>
  *=

Expect:
  aaa     = aaa     = aaa
  aaaaa   = aaaaa   = aaaaa
  aaaaaaa = aaaaaaa = aaaaaaab
  bbbbb=bbbbb=bbbbb
  aaa     = aaa     = aaa

Do (v/b/):
  vip\<Enter>
  \<C-F>v/b/\<Enter>
  *=

Expect:
  aaa   = aaa   = aaa
  aaaaa = aaaaa = aaaaa
  aaaaaaa=aaaaaaa=aaaaaaab
  bbbbb=bbbbb=bbbbb
  aaa   = aaa   = aaa

Do (invalid filter expression):
  vip\<Enter>
  \<C-F>haha\<Enter>
  *=

Expect:
  aaa     = aaa     = aaa
  aaaaa   = aaaaa   = aaaaa
  aaaaaaa = aaaaaaa = aaaaaaab
  bbbbb   = bbbbb   = bbbbb
  aaa     = aaa     = aaa

Execute (g-filter in shorthand notation):
  %EasyAlign*=g/a/

Expect:
  aaa     = aaa     = aaa
  aaaaa   = aaaaa   = aaaaa
  aaaaaaa = aaaaaaa = aaaaaaab
  bbbbb=bbbbb=bbbbb
  aaa     = aaa     = aaa

Execute (v-filter in shorthand notation):
  %EasyAlign*=v/b/

Expect:
  aaa   = aaa   = aaa
  aaaaa = aaaaa = aaaaa
  aaaaaaa=aaaaaaa=aaaaaaab
  bbbbb=bbbbb=bbbbb
  aaa   = aaa   = aaa

Execute (filter in dictionary format):
  %EasyAlign*={'filter': 'v/b/'}

Expect:
  aaa   = aaa   = aaa
  aaaaa = aaaaa = aaaaa
  aaaaaaa=aaaaaaa=aaaaaaab
  bbbbb=bbbbb=bbbbb
  aaa   = aaa   = aaa

Given clojure (filter with blockwise-visual mode):
  (let [a 1
        bbb 2
        ccccc (range
                10 20)]
    (prn [a bbb ccccc]))

Do (filter with blockwise-visual mode):
  f[
  vi[
  \<C-V>
  \<Enter>
  \<C-F>g/^\S\<Enter>
  \<Space>

Expect clojure:
  (let [a     1
        bbb   2
        ccccc (range
                10 20)]
    (prn [a bbb ccccc]))

Given clojure:
  {:user {:plugins [[cider/cider-nrepl "0.9.1"]
                    [lein-kibit "0.0.8"]
                    [lein-licenses "0.1.1"]
                    [lein-marginalia "0.8.0"] ; lein marg
                    [codox "0.8.13"] ; lein doc
                    [com.jakemccrary/lein-test-refresh "0.10.0"] ; lein test-refresh
                    [lein-pprint "1.1.2"]
                    [lein-exec "0.3.5"]
                    [jonase/eastwood "0.2.1"]]
          :dependencies [[slamhound "1.5.5"]]
          :aliases {"slamhound" ["run" "-m" "slam.hound"]}
          :signing {:gpg-key "FEF9C627"}}}

Do (Virtual column should be used in blockwise-visual mode):
  :set ve=block\<Enter>
  f[
  vi[
  \<C-V>
  $20l
  \<Enter>\<Space>

Expect clojure:
  {:user {:plugins [[cider/cider-nrepl                 "0.9.1"]
                    [lein-kibit                        "0.0.8"]
                    [lein-licenses                     "0.1.1"]
                    [lein-marginalia                   "0.8.0"] ; lein marg
                    [codox                             "0.8.13"] ; lein doc
                    [com.jakemccrary/lein-test-refresh "0.10.0"] ; lein test-refresh
                    [lein-pprint                       "1.1.2"]
                    [lein-exec                         "0.3.5"]
                    [jonase/eastwood                   "0.2.1"]]
          :dependencies [[slamhound "1.5.5"]]
          :aliases {"slamhound" ["run" "-m" "slam.hound"]}
          :signing {:gpg-key "FEF9C627"}}}

Then:
  set ve=

###########################################################

Given (hard-tab indentation (#19)):
  		a=1=3
  			bbb=2=4
  			ccccc=4=5
  				fff=4=6

Do (Left alignment):
  vip\<Enter>=

Expect:
  		a       = 1=3
  			bbb   = 2=4
  			ccccc = 4=5
  				fff = 4=6

Do (Right alignment):
  vip\<Enter>\<Enter>=

Expect:
  		      a = 1=3
  			  bbb = 2=4
  			ccccc = 4=5
  				fff = 4=6

Do (Center alignment):
  vip\<Enter>\<Enter>\<Enter>=

Expect:
  		     a   = 1=3
  			  bbb  = 2=4
  			 ccccc = 4=5
  				fff  = 4=6

Do (Left alignment with shallow indentation):
  vip\<Enter>\<C-I>=

Expect:
  		a     = 1=3
  		bbb   = 2=4
  		ccccc = 4=5
  		fff   = 4=6

Do (Center alignment with deep indentation):
  vip\<Enter>\<Enter>\<Enter>\<C-I>\<C-I>=

Expect:
  		      a   = 1=3
  			   bbb  = 2=4
  			  ccccc = 4=5
  				 fff  = 4=6

Given (hard-tab indentation - dictionary (#19)):
  		ddict={'homePage':'360452',
  		'key':'TEST',
  		'name':'DocumentationAPITestingSpace',
  		'type':'global',
  		'url':'http://localhost:8090/display/TEST'}

Do (Right alignment):
  vip\<Enter>\<Enter>:

Expect:
  		ddict={'homePage': '360452',
  		            'key': 'TEST',
  		           'name': 'DocumentationAPITestingSpace',
  		           'type': 'global',
  		            'url': 'http://localhost:8090/display/TEST'}

###########################################################

Given (Two paragraphs (requires vim-repeat)):
  a = 1
  bb = 2
  ccc = 3
  dddd = 4

  d = 1
  cc = 2
  bbb = 3
  aaaa = 4
  _____ = 5

Do (Align and repeat):
  \<Space>Aip\<Enter>=
  6G
  .

Expect:
     a = 1
    bb = 2
   ccc = 3
  dddd = 4

      d = 1
     cc = 2
    bbb = 3
   aaaa = 4
  _____ = 5

Do (Visual-mode operator is also repeatable):
  vip\<Enter>\<Enter>=
  6G
  .

Expect:
     a = 1
    bb = 2
   ccc = 3
  dddd = 4

     d = 1
    cc = 2
   bbb = 3
  aaaa = 4
  _____ = 5

Do (Repeatable in visual mode):
  2GvG\<Space>.

Expect:
  a = 1
     bb = 2
    ccc = 3
   dddd = 4

      d = 1
     cc = 2
    bbb = 3
   aaaa = 4
  _____ = 5

Given:
  :: a : 1
  :: bb : 2
  :: ccc : 3
  :: dd : 4
  :: e : 5

  :: :: a:1
  :: :: b :2
  :: :: ccc : 3
  :: :: dd : 4
  :: :: e : 5
  :: :: f : 6

Do (Blockwise-visual-operator is also repeatable):
  fa
  \<C-V>
  f1
  4j
  \<Enter>:
  7G0
  fa
  .

Expect:
  :: a:   1
  :: bb:  2
  :: ccc:  3
  :: dd:  4
  :: e:   5

  :: :: a:   1
  :: :: b:   2
  :: :: ccc:  3
  :: :: dd:  4
  :: :: e:   5
  :: :: f : 6

###########################################################

Include: include/teardown.vader
./test/run	[[[1
11
#!/bin/bash

cd $(dirname $BASH_SOURCE)

vim -Nu <(cat << EOF
syntax on
for dep in ['vader.vim', 'vim-repeat']
  execute 'set rtp+=' . finddir(dep, expand('~/.vim').'/**')
endfor
set rtp+=..
EOF) +Vader*
./test/tex.vader	[[[1
158
# http://en.wikibooks.org/wiki/LaTeX/Tables

Include: include/setup.vader

Given tex (table with escaped &):
  \begin{tabular}{ l c r }
    1&2&3\\
    44&55&66\\
    777&8\&8&999\\
  \end{tabular}

# FIXME vip doesn't work if folded
Do (Align around all &s and \\s):
  VG\<Enter>*&

Expect tex:
  \begin{tabular}{ l c r }
    1   & 2    & 3   \\
    44  & 55   & 66  \\
    777 & 8\&8 & 999 \\
  \end{tabular}

Do (right-align with explicit ignore_unmatched):
  VG\<Enter>\<Enter>\<C-U>\<C-U>*&

Expect tex:
  \begin{tabular}{ l c r }
      1 &    2 &   3 \\
     44 &   55 &  66 \\
    777 & 8\&8 & 999 \\
  \end{tabular}

Do (center-align with explicit ignore_unmatched):
  VG\<Enter>\<Enter>\<Enter>\<C-U>\<C-U>*&

Expect tex:
  \begin{tabular}{ l c r }
     1  &  2   &  3  \\
    44  &  55  & 66  \\
    777 & 8\&8 & 999 \\
  \end{tabular}

Given tex (simple table with \hline):
  \begin{tabular}{ l c r }
    1&2&3\\ \hline
    44&55&66\\ \hline
    777&8\&&999\\ \hline
  \end{tabular}

Do:
  VG\<Enter>*&

Expect tex:
  \begin{tabular}{ l c r }
    1   & 2   & 3   \\ \hline
    44  & 55  & 66  \\ \hline
    777 & 8\& & 999 \\ \hline
  \end{tabular}

Given tex (table with lines w/o &s):
  \begin{tabular}{|r|l|}
    \hline
    7C0 & hexadecimal \\
    3700&octal \\ \cline{2-2}
    1111100000 & binary \\
    \hline \hline
    1984 & decimal \\
    \hline
  \end{tabular}

Do (left-align*):
  VG\<Enter>*&

Expect tex:
  \begin{tabular}{|r|l|}
    \hline
    7C0        & hexadecimal \\
    3700       & octal       \\ \cline{2-2}
    1111100000 & binary      \\
    \hline \hline
    1984       & decimal     \\
    \hline
  \end{tabular}

Do(left-align* and right-align around 2nd):
  VG\<Enter>*&
  gv\<Enter>\<Enter>2&

Expect tex:
  \begin{tabular}{|r|l|}
    \hline
    7C0        & hexadecimal \\
    3700       &       octal \\ \cline{2-2}
    1111100000 &      binary \\
    \hline \hline
    1984       &     decimal \\
    \hline
  \end{tabular}

Given tex:
  \begin{tabular}{}
    32&1.14\e1&&5.65\e2&&&&1.16\e1&&1.28\e1&\\
    64&1.03\e1&0.1&4.98\e2&0.2&&&9.21\e2&0.3&1.02\e1&0.3\\
    128&9.86\e2&0.1&4.69\e2&0.1&&&8.46\e2&0.1&9.45\e2&0.1\\
    256&9.65\e2&0.0&4.59\e2&0.0&&&8.15\e2&0.1&9.11\e2&0.1\\
  % 512&9.55\e2&0.0&4.56\e2&0.0&&&8.01\e2&0.0&8.96\e2&0.0\\
    1024&9.49\e2&0.0&4.53\e2&0.0&&&7.94\e2&0.0&8.89\e2&0.0\\
    2048&9.47\e2&0.0&4.52\e2&0.0&&&7.91\e2&0.0&8.85\e2&0.0\\
    4096&9.46\e2&0.0&4.51\e2&0.0%&&&7.90\e2&0.0&8.83\e2&0.0\\
    8192&9.45\e2&0.0&4.51\e2&0.0&&&&&&\\
  \end{tabular}

Execute (Alignment around &s, foldmethod should not change):
  setlocal foldmethod=syntax
  %EasyAlign*&
  AssertEqual 'syntax', &l:foldmethod

  setlocal foldmethod=manual
  %EasyAlign*&
  AssertEqual 'manual', &l:foldmethod

Expect tex:
  \begin{tabular}{}
    32   & 1.14\e1 &     & 5.65\e2 &     &  &  & 1.16\e1 &     & 1.28\e1 &     \\
    64   & 1.03\e1 & 0.1 & 4.98\e2 & 0.2 &  &  & 9.21\e2 & 0.3 & 1.02\e1 & 0.3 \\
    128  & 9.86\e2 & 0.1 & 4.69\e2 & 0.1 &  &  & 8.46\e2 & 0.1 & 9.45\e2 & 0.1 \\
    256  & 9.65\e2 & 0.0 & 4.59\e2 & 0.0 &  &  & 8.15\e2 & 0.1 & 9.11\e2 & 0.1 \\
  % 512&9.55\e2&0.0&4.56\e2&0.0&&&8.01\e2&0.0&8.96\e2&0.0\\
    1024 & 9.49\e2 & 0.0 & 4.53\e2 & 0.0 &  &  & 7.94\e2 & 0.0 & 8.89\e2 & 0.0 \\
    2048 & 9.47\e2 & 0.0 & 4.52\e2 & 0.0 &  &  & 7.91\e2 & 0.0 & 8.85\e2 & 0.0 \\
    4096 & 9.46\e2 & 0.0 & 4.51\e2 & 0.0%&&&7.90\e2&0.0&8.83\e2&0.0\\
    8192 & 9.45\e2 & 0.0 & 4.51\e2 & 0.0 &  &  &         &     &         &     \\
  \end{tabular}

Execute (g:easy_align_bypass_fold set, foldmethod should not change):
  let g:easy_align_bypass_fold = 1
  setlocal foldmethod=syntax
  %EasyAlign*&
  AssertEqual 'syntax', &l:foldmethod

  setlocal foldmethod=manual
  %EasyAlign*&
  AssertEqual 'manual', &l:foldmethod

Expect tex:
  \begin{tabular}{}
    32   & 1.14\e1 &     & 5.65\e2 &     &  &  & 1.16\e1 &     & 1.28\e1 &     \\
    64   & 1.03\e1 & 0.1 & 4.98\e2 & 0.2 &  &  & 9.21\e2 & 0.3 & 1.02\e1 & 0.3 \\
    128  & 9.86\e2 & 0.1 & 4.69\e2 & 0.1 &  &  & 8.46\e2 & 0.1 & 9.45\e2 & 0.1 \\
    256  & 9.65\e2 & 0.0 & 4.59\e2 & 0.0 &  &  & 8.15\e2 & 0.1 & 9.11\e2 & 0.1 \\
  % 512&9.55\e2&0.0&4.56\e2&0.0&&&8.01\e2&0.0&8.96\e2&0.0\\
    1024 & 9.49\e2 & 0.0 & 4.53\e2 & 0.0 &  &  & 7.94\e2 & 0.0 & 8.89\e2 & 0.0 \\
    2048 & 9.47\e2 & 0.0 & 4.52\e2 & 0.0 &  &  & 7.91\e2 & 0.0 & 8.85\e2 & 0.0 \\
    4096 & 9.46\e2 & 0.0 & 4.51\e2 & 0.0%&&&7.90\e2&0.0&8.83\e2&0.0\\
    8192 & 9.45\e2 & 0.0 & 4.51\e2 & 0.0 &  &  &         &     &         &     \\
  \end{tabular}

Include: include/teardown.vader
./zip	[[[1
2
#!/bin/sh
git archive -o vim-easy-align.zip HEAD

# ANSI Colors

## Usage

```bash
\033[STYLE;COLOR;BG_COLORmTEXT GOES HERE\33[0m
```

## Styles

| Code      | Effect                            |
| --------- | --------------------------------- |
| `\033[0m` | Reset (normal text)               |
| `\033[1m` | Bold                              |
| `\033[3m` | Italic (not supported everywhere) |
| `\033[4m` | Underline                         |
| `\033[7m` | Inverse (swap fg/bg)              |

## Colors

| Code       | Color   | Example Python Usage              |
| ---------- | ------- | --------------------------------- |
| `\033[30m` | Black   | `print("\033[30mBlack\033[0m")`   |
| `\033[31m` | Red     | `print("\033[31mRed\033[0m")`     |
| `\033[32m` | Green   | `print("\033[32mGreen\033[0m")`   |
| `\033[33m` | Yellow  | `print("\033[33mYellow\033[0m")`  |
| `\033[34m` | Blue    | `print("\033[34mBlue\033[0m")`    |
| `\033[35m` | Magenta | `print("\033[35mMagenta\033[0m")` |
| `\033[36m` | Cyan    | `print("\033[36mCyan\033[0m")`    |
| `\033[37m` | White   | `print("\033[37mWhite\033[0m")`   |

## Background Colors

(same as text colors, but add 40–47 instead of 30–37)

| Code       | Background Color   |
| ---------- | ------------------ |
| `\033[40m` | Black background   |
| `\033[41m` | Red background     |
| `\033[42m` | Green background   |
| `\033[43m` | Yellow background  |
| `\033[44m` | Blue background    |
| `\033[45m` | Magenta background |
| `\033[46m` | Cyan background    |
| `\033[47m` | White background   |

## Example

```python
print("\033[1;31;43mBold Red on Yellow\033[0m")
```

#!/usr/bin/env python

STYLE = 0
NORMAL = 1
SHIFT = 2
CTRL = 3
LAYER_AUX = 4
HOLD = 5

rows = [
    [
        { NORMAL: "=", SHIFT: "+", LAYER_AUX: "F12", },
        { NORMAL: "1", SHIFT: "!", LAYER_AUX: "F1", },
        { NORMAL: "2", SHIFT: "@", LAYER_AUX: "F2", },
        { NORMAL: "3", SHIFT: "#", LAYER_AUX: "F3", },
        { NORMAL: "4", SHIFT: "$", LAYER_AUX: "F4", },
        { NORMAL: "5", SHIFT: "%", LAYER_AUX: "F5", },

        None,
        None,
        None,
        None,
        None,
        None,

        { NORMAL: "6", SHIFT: "^", LAYER_AUX: "F6", },
        { NORMAL: "7", SHIFT: "&", LAYER_AUX: "F7", },
        { NORMAL: "8", SHIFT: "*", LAYER_AUX: "F8", },
        { NORMAL: "9", SHIFT: "(", LAYER_AUX: "F9", },
        { NORMAL: "0", SHIFT: ")", LAYER_AUX: "F10", },
        { NORMAL: "-", SHIFT: "_", LAYER_AUX: "F11", },
    ],

    [
        { NORMAL: "Tab", },
        { NORMAL: "Q", },
        { NORMAL: "W", },
        { NORMAL: "E", },
        { NORMAL: "R", },
        { NORMAL: "T", },

        None,
        None,
        None,
        None,
        None,
        None,

        { NORMAL: "Y", LAYER_AUX: "[", },
        { NORMAL: "U", LAYER_AUX: "]", },
        { NORMAL: "I", LAYER_AUX: "{", },
        { NORMAL: "O", LAYER_AUX: "}", },
        { NORMAL: "P", },
        { NORMAL: "\\", },
    ],

    [
        { NORMAL: "`", SHIFT: "~", },
        { NORMAL: "A", },
        { NORMAL: "S", },
        { NORMAL: "D", },
        { NORMAL: "F", },
        { NORMAL: "G", },

        None,
        None,
        None,
        None,
        None,
        None,

        { NORMAL: "H", LAYER_AUX: "Left", },
        { NORMAL: "J", LAYER_AUX: "Down",},
        { NORMAL: "K", LAYER_AUX: "Up",},
        { NORMAL: "L", LAYER_AUX: "Right",},
        { NORMAL: ";", SHIFT: ":", },
        { NORMAL: "'", SHIFT: "\"", },
    ],

    [
        { NORMAL: "", },
        { NORMAL: "Z", },
        { NORMAL: "X", },
        { NORMAL: "C", },
        { NORMAL: "V", },
        { NORMAL: "B", },

        None,
        None,
        None,
        None,
        None,
        None,

        { NORMAL: "N", LAYER_AUX: "Home", },
        { NORMAL: "M", LAYER_AUX: "PgDn", },
        { NORMAL: ",", LAYER_AUX: "PgUp", SHIFT: "<", },
        { NORMAL: ".", LAYER_AUX: "End", SHIFT: ">", },
        { NORMAL: "/", SHIFT: "?", },
        { NORMAL: "", },
    ],

    [
        None,
        None,
        { NORMAL: "◆ Super", },
        { NORMAL: "<div class=\"layer_aux\">✦ Aux</div>", },
        { NORMAL: "⎋ Esc", },
        { NORMAL: "⌫ Backspace", },
        { NORMAL: "⎈ Ctrl", },

        None,
        None,
        None,
        None,

        { NORMAL: "<div class=\"key_shift\">⇧ Shift</div>", },
        { NORMAL: "␣ Space", },
        { NORMAL: "⏎ Enter", },
        { NORMAL: "Ctrl+B", },
        { NORMAL: "⎇ Alt", },
        None,
        None,
    ],

]

def header():
    print("<!-- https://html-preview.github.io/?url=https://github.com/fomichev/dotfiles/blob/master/keyboard/layout.html -->")

    print("<html>")

    print("<head>")
    print("  <style>")
    print("    table.key-small {")
    print("      border: 1px solid black;")
    print("      border-radius: 5px;")
    print("      width: 120px;")
    print("      height: 60px;")
    print("    }")
    print("    table.key {")
    print("      border: 1px solid black;")
    print("      border-radius: 5px;")
    print("      width: 120px;")
    print("      height: 120px;")
    print("    }")
    print("    .layer_aux {")
    print("      color: red;")
    print("    }")
    print("    .key_shift {")
    print("      color: green;")
    print("    }")
    print("    .key_norm {")
    print("      text-align: center;")
    print("    }")
    print("    .key_ctrl {")
    print("      color: blue;")
    print("    }")
    print("    .key_hold {")
    print("      color: green;")
    print("    }")
    print("  </style>")
    print("</head>")

    print("<body>")

    print("<table>")

def footer():
    print("</table>")

    print("</body>")
    print("</html>")

def format_key(kd):
    norm = kd[NORMAL]
    style = kd.get(STYLE, "key")
    shift = kd.get(SHIFT, "&nbsp;")
    ctrl = kd.get(CTRL, "&nbsp;")
    hold = kd.get(HOLD, "&nbsp;")
    layer_aux = kd.get(LAYER_AUX, "&nbsp;")

    return """
        <table class="{style}">
          <tr>
            <td>
                <table width="100%">
                    <tr>
                        <td><div class="layer_aux">{layer_aux}</div></td>
                        <td><div class="key_shift">{shift}</div></td>
                    <tr>
                </table>
            </td>
          </tr>
          <tr>
            <td>
                <div class="key_norm">{norm}</div>
            </td>
          </tr>
          <tr>
            <td>
                <span class="key_ctrl">{ctrl}</span>
                <span class="key_hold">{hold}</span>
            </td>
          </tr>
        </table>
    """.format(
        style = style,
        norm = norm,
        shift = shift,
        ctrl = ctrl,
        hold = hold,
        layer_aux = layer_aux,
    )

def body():
    for row in rows:
        print("<tr>")
        for col in row:
            if not col:
                print("<td></td>")
                continue

            print("<td>{}</td>".format(format_key(col)))
        print("</tr>")

    pass

header()
body()
footer()

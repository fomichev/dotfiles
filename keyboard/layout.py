#!/usr/bin/env python

STYLE = 0
NORMAL = 1
SHIFT = 2
HOLD = 3
LAYER_AUX = 4

rows = [
    [
        { STYLE: "key-small", NORMAL: "ESC", },
        { STYLE: "key-small", NORMAL: "F1", },
        { STYLE: "key-small", NORMAL: "F2", },
        { STYLE: "key-small", NORMAL: "F3", },
        { STYLE: "key-small", NORMAL: "F4", },
        { STYLE: "key-small", NORMAL: "F5", },

        { STYLE: "key-small", NORMAL: "F6", },
        { STYLE: "key-small", NORMAL: "F7", },
        { STYLE: "key-small", NORMAL: "F8", },
        { STYLE: "key-small", NORMAL: "F9", },
        { STYLE: "key-small", NORMAL: "F10", },
        { STYLE: "key-small", NORMAL: "F11", },

        { STYLE: "key-small", NORMAL: "F12", },
        { STYLE: "key-small", NORMAL: "PrnScr", },
        { STYLE: "key-small", NORMAL: "-Vol", },
        { STYLE: "key-small", NORMAL: "Pause", },
        { STYLE: "key-small", NORMAL: "+Vol", },
        { STYLE: "key-small", NORMAL: "Mute", },
    ],

    [
        { NORMAL: "=", SHIFT: "+", LAYER_AUX: "TapDelay+", },
        { NORMAL: "1", SHIFT: "!", },
        { NORMAL: "2", SHIFT: "@", },
        { NORMAL: "3", SHIFT: "#", },
        { NORMAL: "4", SHIFT: "$", },
        { NORMAL: "5", SHIFT: "%", },

        None,
        None,
        None,
        None,
        None,
        None,

        { NORMAL: "6", SHIFT: "^", },
        { NORMAL: "7", SHIFT: "&", },
        { NORMAL: "8", SHIFT: "*", },
        { NORMAL: "9", SHIFT: "(", },
        { NORMAL: "0", SHIFT: ")", },
        { NORMAL: "-", SHIFT: "_", LAYER_AUX: "TapDelay-", },
    ],

    [
        { NORMAL: "Tab", LAYER_AUX: "TapDelay", },
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

        { NORMAL: "Y", },
        { NORMAL: "U", },
        { NORMAL: "I", },
        { NORMAL: "O", },
        { NORMAL: "P", },
        { NORMAL: "\\", SHIFT: "|", },
    ],

    [
        { NORMAL: "`", SHIFT: "~", },
        { NORMAL: "A", },
        { NORMAL: "S", },
        { NORMAL: "D", LAYER_AUX: "ScrnPrv", },
        { NORMAL: "F", LAYER_AUX: "ScrnNxt", },
        { NORMAL: "G", LAYER_AUX: "RU_EN", },

        None,
        None,
        None,
        None,
        None,
        None,

        { NORMAL: "H", LAYER_AUX: "🖱️ Left", },
        { NORMAL: "J", LAYER_AUX: "🖱️ Down",},
        { NORMAL: "K", LAYER_AUX: "🖱️ Up",},
        { NORMAL: "L", LAYER_AUX: "🖱️ Right",},
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

        { NORMAL: "N", LAYER_AUX: "🛞 Left", },
        { NORMAL: "M", LAYER_AUX: "🛞 Down", },
        { NORMAL: ",", LAYER_AUX: "🛞 Up", SHIFT: "<", },
        { NORMAL: ".", LAYER_AUX: "🛞 Right", SHIFT: ">", },
        { NORMAL: "/", SHIFT: "?", },
        { NORMAL: "", },
    ],

    [
        None,
        { NORMAL: "<", LAYER_AUX: "PRG", },
        { NORMAL: "(", },
        { NORMAL: "{", },
        { NORMAL: "[", },
        None,

        None,
        None,
        None,
        None,
        None,
        None,

        None,
        { NORMAL: "]", },
        { NORMAL: "}", },
        { NORMAL: ")", },
        { NORMAL: ">", LAYER_AUX: "DBG", },
        None,
    ],

    [
        None,
        None,
        None,
        None,
        None,
        None,

        { NORMAL: "Esc", HOLD: "Ctrl", },
        { NORMAL: "Super", HOLD: "<div class=\"layer_aux\">Aux</div>", },
        None,
        None,
        { NORMAL: "Super", HOLD: "<div class=\"layer_aux\">Aux</div>", },
        { NORMAL: "Esc", HOLD: "Ctrl", },

        None,
        None,
        None,
        None,
        None,
        None,
    ],

    [
        None,
        None,
        None,
        None,
        None,
        None,

        None,
        { NORMAL: "Left", SHIFT: "Home", },
        None,
        None,
        { NORMAL: "Up", SHIFT: "PgUp", },
        None,

        None,
        None,
        None,
        None,
        None,
        None,
    ],

    [
        None,
        None,
        None,
        None,
        None,
        { NORMAL: "Backpace", HOLD: "<div class=\"key_shift\">Shift</div>", },

        { NORMAL: "Delete", HOLD: "Alt", },
        { NORMAL: "Right", SHIFT: "End", },
        None,
        None,
        { NORMAL: "Down", SHIFT: "PgDn", LAYER_AUX: "🖱️ MB", },
        { NORMAL: "Enter", HOLD: "Alt", LAYER_AUX: "🖱️ LB", },

        { NORMAL: "Space", HOLD: "<div class=\"key_shift\">Shift</div>", LAYER_AUX: "🖱️ RB", },
        None,
        None,
        None,
        None,
        None,
    ],


]

def header():
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
    print("      text-align: left;")
    print("      color: red;")
    print("      font-weight: bold;")
    print("    }")
    print("    .key_shift {")
    print("      text-align: right;")
    print("      color: green;")
    print("    }")
    print("    .key_norm {")
    print("      text-align: center;")
    print("    }")
    print("    .key_hold {")
    print("      text-align: left;")
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
    hold = kd.get(HOLD, "&nbsp;")
    layer_aux = kd.get(LAYER_AUX, "&nbsp;")

    return """
        <table class="{style}">
          <tr>
            <td>
                <table>
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
                <div class="key_hold">{hold}</div>
            </td>
          </tr>
        </table>
    """.format(
        style = style,
        norm = norm,
        shift = shift,
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

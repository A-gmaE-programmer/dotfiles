# Command palette 
# TODO:
#  - Apt update?
#  - align / resize: commands to control floating windows
#  - Ways to trigger different scripts
#  - splitratio <n> -> Will automatically set it to that
#  - groupall -> group all windows
#  - dispatch -> hyprctl dispatch

from io import BytesIO
from subprocess import run
from time import sleep

rofi_command = "rofi -show -i -dmenu -l 10"
rofi_opts = b'''\
term [resize] -> Launch a floating terminal
run [resize] <command> -> Run a command in a floating termnal
dispatch <command> -> Hyprctl dispatch
splitratio <ratio>
splitexact <exact ratio>
yank ws <workspace> -> Yank a workspace
sunset
sungone
overview
sre half
btop
htop
python
'''
# Neofetch?

# os.system("hyprctl dispatch overview:toggle")
command = run(rofi_command.split(), input=rofi_opts, capture_output=True).stdout

print(command)

def dispatch(command: list[str] | str):
    if isinstance(command, str):
        command = command.strip().split()
    print("Command: ", command)
    # print("Running: ", ["hyprctl", "dispatch", *command])
    print("Hyprctl:",
        run(["hyprctl", "dispatch", *command], capture_output=True)
        .stdout
        .decode('ascii')
        )
    pass

def float_term(command: str = "", x=800, y=450):
    print("Lauching term with command:", command)
    dispatch([
        "exec",
        "[floating;center;size {x} {y}]".format(x=x, y=y),
            "qterminal -e \"{cmd}\"".format(cmd=command)
        if command else
            "qterminal"
    ])

def calc_resize(args: str = "", extra: float = 1.0):
    WIDTH = int(800 * extra)
    HEIGHT = int(450 * extra)
    if not args:
        return WIDTH, HEIGHT, args
    resize_str, *cmd_args = args.split(" ", 1)
    # if resize_str == "max":
    #     return 1920, 1080, cmd_args[0] if cmd_args else ""
    if args[0] not in "1234567890.":
        return WIDTH, HEIGHT, args
    print(args.encode())
    try:
        resize = float(resize_str)
    except ValueError:
        return WIDTH, HEIGHT, args

    x = int(WIDTH * resize)
    y = int(HEIGHT * resize)
    cmd_args = cmd_args[0] if cmd_args else ""
    return x, y, cmd_args


def main(command: str):
    prefix, *args = command.strip().split(" ", 1)
    args = args[0] if args else ""

    match prefix:
        case "term" | "run":
            if args == "[resize] -> Launch a floating terminal"\
            or args == "[resize] <command> -> Run a command in a floating termnal":
                float_term()
            else:
                x, y, args = calc_resize(args)
                float_term(args, x, y)

        case "dispatch":
            if args != "<command> -> Hyprctl dispatch":
                dispatch(args)

        case "splitratio" | "sr":
            dispatch("splitratio "+args)
            if args == "main":
                dispatch("splitratio exact .75")
        case "splitexact" | "sre":
            if args == "half":
                dispatch("splitratio exact .5")
            elif args == "main":
                dispatch("splitratio exact .75")
            dispatch("splitratio exact "+args)

        case "yank": # TODO implement window yanking -> Yank a window to current workspace and push it back 'throw'
            thing, subargs = args.strip().split(" ", 1)
            print(thing, subargs)
            if subargs and thing == "ws":
                dispatch("focusworkspaceoncurrentmonitor "+subargs[0])

        case "sunset":
            run(["wlsunset", "-g", "1.1", "-T", "5500"])
        case "sungone":
            run("kill $(pidof wlsunset)", shell=True)

        case "overview":
            sleep(1)
            dispatch("overview:toggle")

        case "btop":
            x, y, args = calc_resize(args, 1.6)
            float_term("btop --utf-force" + args, x, y)
        case "htop":
            x, y, args = calc_resize(args, 1.3)
            float_term("htop" + args, x, y)
        case "python":
            x, y, args = calc_resize(args)
            if args:
                float_term("python" + args, x, y)
            else:
                float_term("bpython", x, y)

main(command.decode('ascii'))

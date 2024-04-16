from subprocess import run
print("toggling overview")
run('hyprctl dispatch overview:toggle', shell=True)

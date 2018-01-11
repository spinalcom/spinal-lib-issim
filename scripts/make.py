#!/usr/bin/python2

from concat_js import *

models = []
processes = []
stylesheets = []

for p in os.listdir( "src" ):
    for m in os.listdir("src/" + p):
        if m == "models":
            models.append("gen/" + m + "/" + p + ".js")
            concat_js( "src/" + p + "/" + m, "gen/" + m + "/" + p + ".js", "gen/stylesheets/" + p + ".css" )

        elif m == "views":
            processes.append("gen/" + m + "/" + p + ".js")
            concat_js( "src/" + p + "/" + m, "gen/" + m + "/" + p + ".js", "gen/stylesheets/" + p + ".css" )

        elif m == "stylesheets":
            stylesheets.append("gen/" + m + "/" + p + ".css")
            concat_js( "src/" + p + "/" + m, "gen/" + m + "/" + p + ".js", "gen/stylesheets/" + p + ".css" )

exec_cmd_silent( "cat scripts/module_base.js > lib.js " )
exec_cmd_silent( "echo > stylesheets.css " )

print ("\033[0;35mConcat file : models.js\033[m");
for m in sorted(models):
    exec_cmd_silent( "cat " + m + " >> lib.js" )
print ("\033[0;35mConcat file : processes.js\033[m");
for p in sorted(processes):
    exec_cmd_silent( "cat " + p + " >> lib.js" )
print ("\033[0;35mConcat file : stylesheets.css\033[m");
for s in sorted(stylesheets):
    exec_cmd_silent( "cat stylesheets.css " + s + " >> stylesheets_tmp.css" )
    exec_cmd_silent( "mv stylesheets_tmp.css stylesheets.css" )

# The default branch has been renamed!
main is now named master
If you have a local clone, you can update it by running the following commands.
'''
git branch -m main master
git fetch origin
git branch -u origin/master master
git remote set-head origin -a
'''
```
# 1. Create new Github repository.
git init
git remote add origin git@github.com:bakhtiyork/devops-tasks.git


# 2. Create Task1 folder in the master branch. Create and push ./Task1/README.md file.
mkdir Task1
touch Task1/README.md
git add Task1
git commit -m "First commit"
git push -u origin master


# 3. Create new branch dev. Create and push any test file.
git checkout -b dev
touch LICENSE
git add LICENSE
git commit -m "Second commit"
git push -u origin dev


# 4. Create new branch %USERNAME-new_feature.
git checkout -b bakhtiyork-new_feature


# 5. Add README.md file to your %USERNAME-new_feature branch
touch README.md
git add README.md


# 6. Check your repo with git status command
git status


# 7. Add .gitignore file to ignore all files whose name begins “.”
echo '.*' > .gitignore
echo '!.gitignore' >> .gitignore
git add .gitignore


# 8. Commit and push changes to github repo.
git commit -m "Third commit"
git push -u origin bakhtiyork-new_feature

git fetch --all


# 11. Checkout to %USERNAME-new_feature, make changes in README.md and commit them. Revert last commit in %USERNAME-new_feature branch.
git checkout bakhtiyork-new_feature
git pull
echo '* Title' >> README.md
git add README.md
git commit -m "Fourth commit"
git reset --hard HEAD~1


# 12. Check your repo with git log command, create log.txt file in master branch and save “git log” output in it.
git checkout master
git pull
git log > log.txt
git add log.txt
git commit -m "Log output"
git push


# 13. Delete local and remote branch %USERNAME-new_feature.
git branch -d bakhtiyork-new_feature


# 14. Add all used command to the git_commands.md file in the dev branch
git checkout dev
git pull

```

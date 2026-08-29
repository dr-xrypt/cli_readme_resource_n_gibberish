git config --global user.name "DisplayUSERNAMEinproject"
git config --global user.email "bernardcsunday@gmail.com"
git config --list

git init
#create files that will be tracked by git
git config user.name "DisplayUSERNAMEinproject"
git remote add origin "https://github/user/gitreporemotelink.git"
git remote -v

git add (. or --all) or (filename(s))
git rm --cached -r .
git status
git commit -m "Description of Recent file commits"

git branch # show local branches and check current branch
git branch -r # show remote branches
git branch -a # show all branches (local and remote)
git branch BranchName # creates a branch named BranchName, does not switch to it
git branch -m BranchName #rename current branch
git branch -m OldBranchName NewBranchName #rename other branch
git branch -d master #delete branch from local repobase
git branch --unset-upstream      # Remove old tracking (--unset-upstream when removing the remote default branch)

git checkout main # switch to and select branch (git switch main) main
git checkout -b BranchName # creates and switches to BranchName

git switch main # switch to and select branch (git checkout main) main
git switch -c BranchName # creates and switches to BranchName

git merge BranchName # takes committed changes from BranchName and commits them to current working branch

git clone "https://github/user/gitreporemotelink.git"
git fetch #get new commits without merging
git pull # get new commits and merge them

git push --set-upstream origin main # set origin/main as default branch to push and pull
git push origin --delete master # delete branch from remote repo base

#login on linux with ssh 
ls ~/.ssh #check for ssh 

ssh-keygen -t ed25519 -C "your-email@example.com"


# Copy your public key:

cat ~/.ssh/id_ed25519.pub #copy the output
# Go to GitHub → Settings → SSH and GPG keys → New SSH key
# Paste the key, give it a name (like "My Laptop"), and save

git clone git@github.com:user/repo.git

ssh -T git@github.com # to test if login successful


git fetch origin
git checkout production
git reset --hard origin/main
git push origin production --force
git checkout main
git branch -D production 
git branch
echo "done"


# 1. Get the absolute latest state from the remote
git fetch origin
# 2. Switch to production (create it locally if it doesn't exist)
git checkout production || git checkout -b production origin/production
# 3. Safely update production to match main. 
# This WILL FAIL automatically if code would be destroyed.
git merge --ff-only origin/main
# 4. Standard push (No --force needed!)
git push origin production
# 5. Clean up local state and exit
git checkout main
git branch -D production
echo "Deploy successful!"


# 1. Fetch latest updates
git fetch origin
# 2. Switch to production
git checkout production || git checkout -b production origin/production
# 3. Merge main into production. 
# This combines both histories safely.
git merge -m "Automated deploy from main" origin/main
# 4. Standard safe push
git push origin production
# 5. Clean up
git checkout main
git branch -D production
echo "Deploy successful!"

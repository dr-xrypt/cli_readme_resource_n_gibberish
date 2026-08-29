# Navigate to folder you want the app folder to be on
composer create-project laravel/laravel AppName --prefer-dist

composer global require "laravel/installer" # This will install laravel to path (Not necessary as above line can also install laravel)
laravel new AppName # Do this if laravel has been installed from composer to system path

git clone https://github.com/user/AppName.git #Do this if you're cloning from GIt repo

# Answer All prompts
# Successfully Created app

cd AppName
Configure .env file

php artisan migrate # To run database migrate
php artisan serve # To serve the app in development
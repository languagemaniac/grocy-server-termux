# grocy-server-termux

I found [this](https://www.reddit.com/r/grocy/comments/x5vcv0/installation_guide_to_run_grocy_on_android_using/) Reddit post that explained how to install grocy server on termux, but to make things easy I asked ChatGPT to create an installation script for me so I just had to execute it and it would take care of everything.

So In order to install grocy on termux you have to follow this simple guide:

1. Download the required dependencies by running:

    pkg install -y nginx sqlite php-fpm termux-services wget

2. Exit termux, close the session and open it again.

3. Download the script provided here

4. Make the script executable by running: 
    
    chmod +x setup.sh

5. Execute the script by running : 

    ./setup.sh

This will make grocy server available on 127.0.0.1:8080 although In my case for some reason the server couldn't run on port 8080, when accessing the page i could see nginx but said it needed configuring. If you face the same issue, edit this file but running the command:

  nano $PREFIX/etc/nginx/sites-enabled/default

And change 8080 for 8081 for example.

To edit your Config.php file to edit the currency and some other things:

    nano $PREFIX/var/www/html/data/config.php

To restart your grocy server:


  sv restart php-fpm
  
  sv restart nginx




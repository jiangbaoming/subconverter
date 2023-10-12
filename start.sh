#/bin/sh
if [ ! -f /usr/share/nginx/html/conf/config.js ]; then
  cp /app/conf/config.js /usr/share/nginx/html/conf
fi

nohup /base/subconverter & echo "启动成功"

init_nginx (){
  sed -i '$d' /etc/nginx/conf.d/default.conf
  sed -i '$d' /etc/nginx/conf.d/default.conf
  sed -i '$d' /etc/nginx/conf.d/default.conf
  cat >> /etc/nginx/conf.d/default.conf <<EOF
    location ~* /(version|sub|render|getruleset|surge2clash|getprofile) {
        proxy_redirect off;
        proxy_pass http://127.0.0.1:25500;
    }
  }
EOF
}

if [[ ! $(cat /etc/nginx/conf.d/default.conf | grep 25500) ]]; then
	init_nginx
fi

nginx -g "daemon off;"
node {
    stage('download') {
        git branch: 'main', url: 'https://github.com/dipon778/velflix.git'
    }
    stage('install') {
        sh 'composer install'
    }
    stage('init') {
    	sh '''
    	cp .env.example .env
    	php artisan key:generate
    	sed -i -e 's/DB_PASSWORD=homestead/DB_PASSWORD=password/g' .env
    	sed -i -e 's/DB_DATABASE=homestead/DB_DATABASE=velflix/g' .env
    	sed -i -e 's/DB_HOST=homestead/DB_HOST=localhost/g' .env
    	sed -i -e 's/DB_USERNAME=homestead/DB_USERNAME=root/g' .env
    	sed -i -e 's/TMDB_TOKEN=homestead/TMDB_TOKEN=eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyMDQ0ZmJmMjBlZTQ1Y2JmMDJkYTQ5Zjk4NDk3NTZiOSIsInN1YiI6IjY2M2JiOWQzM2ZiZmVjZDVkNzA1ZDQwNCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.A0xaHvjWf1ykSVJ7ZL170mJcXfvs4bu17oCHuDcZ9Q4/g' .env
    	
        npm install && npm run build
    	php artisan migrate
    	php artisan db:seed
    	
    	sudo rm -rf /var/www/velflix/*
    	pwd
    	sudo mv  * /var/www/velflix
    	
    	cd /var/www/velflix
    	sudo chown -R www-data storage
        sudo chown -R www-data bootstrap/cache
    	sudo systemctl restart nginx
    	
    	'''
    }
//     stage('integration_testing') {
//     	sh 'vendor/bin/phpunit tests/Feature'
//     }
//     stage('acceptance_testing') {
//     	// Because we'll use database as session driver during testing, we have to explictly migrate sessions table.
//         sh 'php artisan migrate'
//     	sh 'cp .env .env.dusk.local'
//     	sh "sed -i -e 's;APP_URL=http://localhost;APP_URL=your.domain.com;g' .env.dusk.local"
//     	// Use database as session driver instead of file so that every single test will not share the same session context.
//     	sh "sed -i -e 's/SESSION_DRIVER=file/SESSION_DRIVER=database/g' .env.dusk.local"
//     	// Allow web server to access storage directory.
//     	sh 'sudo chmod -R 775 storage/'
//     	sh 'sudo chown -R :www-data storage/'
//     	sh 'php artisan dusk'
//     }
}
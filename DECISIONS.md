Para hacer que sea mas rápida la comprobación de las MR, he hecho que no se genere la imagen en cada commit en una MR, asi los test se ejecutaran antes en las github actions. 

Sobre los tags, al tener tan poco tiempo, hice con chatgpt un pequeño script que obtiene el último tag y le suma un digito al mismo. Lo suyo seria usar semver para los tags con alguna aplicación que lea los commits y suba la versión del mismo. Ahora mismo se genera un nuevo tag con cada mergeo de merge request. 

Por último, cada vez que tenemos un tag, se ejecuta un workflow que sube la misma a github con los valores de dicha tag y latest. 
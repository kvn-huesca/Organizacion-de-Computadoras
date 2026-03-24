nothing: 
	echo "nada"
guardar: 
	git status
	git add .
	git commit -m "guardando"
	git push
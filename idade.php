<?php
	
	// Função para demonstrar o uso de Return ao invez de utilizar Else.

	function cinema($minhaIdade){
		if ($minhaIdade > 18) {
			return 'Você pode assistir a este filme IDADE: ' . $minhaIdade;
		}
			return 'Você não pode assistir a este filme IDADE: ' . $minhaIdade;
	}

	echo cinema(21);
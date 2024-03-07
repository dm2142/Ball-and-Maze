library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.STD_LOGIC_ARITH.all;


-- Entidad generada para comutar el valor de una salida al presionar un boton.

entity SwitchBoton is		
	 port(
	 	 BOTON1 	: in STD_LOGIC;		--	Entrada del boton.
		 FLAG 		: out STD_LOGIC		--	Salida correspondiente al cambio de estado al presionar el boton.
	     );
end SwitchBoton;


architecture simple of SwitchBoton is

signal sw : STD_LOGIC:='0';

begin				
	
	FLAG <= sw;
	
	-- Proceso para detectar cuando se presiona el boton, cambiar el estado de la salida.
	Mux1: process(BOTON1, sw) is
	begin 		  	  
		if ( BOTON1'event and BOTON1 = '0') then
			sw <= not(sw);
		end if;
	end process Mux1;


end simple;
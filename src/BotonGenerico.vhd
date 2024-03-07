library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.STD_LOGIC_ARITH.all;


entity BotonGenerico is		
	 port(
	 	 CLK 		: in STD_LOGIC;		--  Reloj Maestro
	 	 BOTON 		: in STD_LOGIC;		
		 FLAG 		: out STD_LOGIC		
	     );
end BotonGenerico;


architecture simple of BotonGenerico is

signal Bp, Bn : STD_LOGIC:='0';

begin				
	
	-- Proceso para detectar cuando se presiona y suelta un botón, enviando una bandera en alto.
	Button: process(Bp, BOTON) is
	begin 
		case Bp is
			when '0' =>
				if( BOTON = '0' ) then
					Bn <= '1';
					flag <= '1';	
				Else		   
					Bn <= Bp;
					flag <= '1';
				end if;
			when '1' =>
				if( BOTON = '1') then
					Bn <= '0';
					flag <= '0';
				Else 
					Bn <= Bp;
					flag <= '1';
				end if;
			when others => flag <= '1';
		end case;
	end process Button;
	
	-- Actualización de los estados en los procesos anteriores.
	combinacional: process(CLK, Bn) is		--	Registro
	begin		   
		if CLK'event and CLK = '1' then
			Bp <= Bn;
		end if;
	end process combinacional;

end simple;
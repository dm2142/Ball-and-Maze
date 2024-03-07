library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.STD_LOGIC_ARITH.all;


-- Entidad generada para la recepción de una cuenta de 4 bits y mostrar su valor en un display de 7 segmentos.

entity DisplaySieteSegmentos is		
	 port(
		 COUNT 		: in STD_LOGIC_VECTOR(3 downto 0);		--	Entrada del número a convertir y mostrar en el display.
		 DISPLAY 	: out STD_LOGIC_VECTOR(7 downto 0)		--	Salida con la cuenta actual al correspondiente LED del display.
	     );
end DisplaySieteSegmentos;


architecture simple of DisplaySieteSegmentos is

begin				
	
	Mux: process( COUNT ) is
	begin			
		case COUNT is
			when "0000" => 	-- 0
				DISPLAY <= "11000000";
			when "0001" =>	-- 1
				DISPLAY <= "11111001";
			when "0010" => 	-- 2
				DISPLAY <= "10100100";
			when "0011" =>	-- 3
				DISPLAY <= "10110000";
			when "0100" => 	-- 4
				DISPLAY <= "10011001";
			when "0101" =>	-- 5
				DISPLAY <= "10010010";
			when "0110" => 	-- 6
				DISPLAY <= "10000010";
			when "0111" =>	-- 7
				DISPLAY <= "11111000";
			when "1000" => 	-- 8
				DISPLAY <= "10000000";
			when "1001" =>	-- 9
				DISPLAY <= "10011000";
			when others => 	-- 0
				DISPLAY <= "11000000";
		end case;
	end process Mux;			

end simple;
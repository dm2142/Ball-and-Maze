library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.STD_LOGIC_ARITH.all;


-- Contador gen�rico de 0 a 5 que se actualiza con cada flanco de subida de la Base de Tiempo.

entity Contador5 is		
	 port(
		 BdT 		: in STD_LOGIC;							--	Entrada de la Base de Tiempo.
		 RST 		: in STD_LOGIC;							--	Reset maestro.
		 COUNT 		: out STD_LOGIC_VECTOR(3 downto 0)		--	Salida con la cuenta actual 0 a 5 (Para llevar a un BCD to 7 segm.)
	     );
end Contador5;


architecture simple of Contador5 is
signal Qp,Qn : STD_LOGIC_VECTOR(3 downto 0):=(others =>'0');	--	Estado presente y siguiente del contador

begin							
	
	COUNT <= Qp;
	
	Mux: process( Qp ) is
	begin	
		case Qp is
			when "0000" => 
				Qn <= "0001";
			when "0001" =>
				Qn <= "0010";
			when "0010" => 
				Qn <= "0011";
			when "0011" =>
				Qn <= "0100";
			when "0100" => 
				Qn <= "0101";
			when "0101" =>    	-- Termina la cuenta  -> 5
				Qn <= "0000";	 -- Reinicia valor de Qp;
			when others => 
				Qn <= "0000";
		end case;
	end process Mux;
	
	
	combinacional: process(BdT, RST, Qn) is		--	Proceso para actualizar el valor del estado presente con cada flanco de subida de la Base de Tiempo.
	begin		   
		if RST = '1' then
			Qp <= (others=>'0');
		elsif rising_edge( BdT ) then
			Qp <= Qn; 
		end if;
	end process combinacional;

end simple;
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.STD_LOGIC_ARITH.all;


-- Contador gen�rico de 0 a 5 que se actualiza con cada flanco de subida de la Base de Tiempo.

entity Contador5_alt is		
	 port(
		 BdT 		: in STD_LOGIC;							--	Entrada de la Base de Tiempo.
		 RST 		: in STD_LOGIC;							--	Reset maestro.
		 H 			: in STD_LOGIC;							--	Habilitador de conteo maestro.
		 COUNT 		: out STD_LOGIC_VECTOR(3 downto 0);		--	Salida con la cuenta actual 0 a 6 (Para llevar a un BCD to 7 segm.)
		 NEXTNUM	: out STD_LOGIC							--  Salida que indica cuando la cuenta se desborda, de 5 a 0.
	     );
end Contador5_alt;


architecture simple of Contador5_alt is
signal Qp,Qn : STD_LOGIC_VECTOR(3 downto 0):=(others =>'0');	--	Estado presente y siguiente del contador
signal flag  : STD_LOGIC := '0';

begin							
	
	COUNT <= Qp;
	
	Mux: process( Qp ) is
	begin	
		case Qp is
			when "0000" => 
				Qn <= "0001";
			when "0001" =>
				Qn <= "0010";
				flag <= '0';
			when "0010" => 
				Qn <= "0011";
				flag <= '0';
			when "0011" =>
				Qn <= "0100";
				flag <= '0';
			when "0100" => 
				Qn <= "0101";
				flag <= '0';
			when "0101" =>    	-- Termina la cuenta  -> 5
				Qn <= "0000";	 -- Reinicia valor de Qp;
				flag <= '1';
			when "0110" =>    	-- Termina la cuenta  -> 6
				Qn <= "0000";	 -- Reinicia valor de Qp;
			when others => 
				Qn <= "0000";
		end case;
	end process Mux;
	
	comparador: process(flag, Qp, H) is
	begin
		if( flag = '1' and Qp = "0000" and flag'last_value = '0' and H ='1')	then
			NEXTNUM <= '1';
		elsif( flag = '0') then
			NEXTNUM <= '0';
		end if;			
	end process comparador;
	
	combinacional: process(BdT, RST, Qn) is		--	Proceso para actualizar el valor del estado presente con cada flanco de subida de la Base de Tiempo.
	begin		   
		if RST = '1' then
			Qp <= (others=>'0');
		elsif rising_edge( BdT ) then
			Qp <= Qn; 
		end if;
	end process combinacional;

end simple;
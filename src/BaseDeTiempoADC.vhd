library IEEE;
use IEEE.STD_logic_1164.all;
use IEEE.STD_logic_UNSIGNED.all;
use IEEE.std_logic_ARITH.all;

entity BaseDeTiempoADC is
	generic(
	  K: integer:= 25000000;
	  N: integer:=27
	  );
	 port(
	  CLK : in std_logic;
	  RST : in std_logic;
	  H : in std_logic;
	  BT : out std_logic
	 );	
end BaseDeTiempoADC;

architecture behavioral of BaseDeTiempoADC is
signal Qp,Qn : std_logic_vector(N-1 downto 0):=(others =>'0');
signal BdT, Cp : std_logic:='0';
signal BdTconH : std_logic_vector(1 downto 0):=(others =>'0');
begin
	BT<= Cp;
	BdTconH <= BdT & H;
	
	Mux: process(BdTconH,Qp) is
	begin
		case BdTconH is
			when "01" => Qn <=Qp+1;
			when "11" => Qn <=(others=>'0');
			when others => Qn <= Qp;
		end case;
	end process Mux;  
	
	Comparator: process(Qp) is
	begin
		if Qp = K then
			BdT <= '1';
			if Cp <= '0' then
				Cp <= '1';
		elsif Cp='1' then
			Cp <= '0';
			end if;
		else
			BdT <= '0';
		end if;
	end process Comparator;
	
	combinacional: process(CLK, RST) is
	begin
		if RST = '0' then
			Qp <= (others =>'0');
		elsif CLK'event and CLK = '1' then
			Qp <= Qn;
		end if;
	end process combinacional;
	end architecture;

	
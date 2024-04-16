pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
--ed rocha te amo =================================================================================================================================================================+
function _init()
 --inicia o mouse -----------------------------------------------------------------------------------------------------------------------------------------------------------------+
 poke(0x5f2d, 1)
 --cus ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
 espacamento  = 0
 
 cu1 = nil
 cu2 = nil
 cu3 = nil
 cu4 = nil
 cu5 = nil
 cu6 = nil
 cu7 = nil
 cu8 = nil
 cu9 = nil

 str1 = ""
 str2 = "" 
 str3 = ""
 str4 = ""
 str5 = ""
 str6 = ""
 str7 = ""
 str8 = ""
 str9 = ""

 --status -------------------------------------------------------------------------------------------------------------------------------------------------------------------------+	
 --[[
 status
 1 para a tela principal
 2 para loja
 3 para o deposito
 ]]
 status = 1

 --auxiliares ---------------------------------------------------------------------------------------------------------------------------------------------------------------------+
 aux_tipo  = 1
 saldo     = 8000
 grav      = 2
		
 --listas -------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
 ls_tst     = {["tipo"]="teste"       ,["val"]=false,["qual"]=nil}
 ls_bts     = {["tipo"]="botao"       ,["val"]=false,["qual"]=nil}
 ls_esp     = {["tipo"]="espaco"      ,["val"]=false,["qual"]=nil                              ,["timer"]=0,["wait"]=false} 
 ls_plv     = {["tipo"]="palavra"     ,["val"]=false,["qual"]=nil}
 ls_atl     = {["tipo"]="atalho"      ,["val"]=false,["qual"]=nil,["atls"  ]={},["show" ]=false,["timer"]=0,["wait"]=false} 
 ls_car     = {["tipo"]="carrinho"    ,["val"]=false,["qual"]=nil,["coisas"]={},["total"]=0    ,["timer"]=0,["wait"]=false} 
 ls_inv     = {["tipo"]="inventario"  ,["val"]=true ,["qual"]=nil,["coisas"]={},                ["timer"]=0,["wait"]=false} 
 ls_jrd     = {["tipo"]="jardim"      ,["val"]=true ,["qual"]=nil,["coisas"]={},                ["timer"]=0,["wait"]=false} 
 ls_prt     = {["tipo"]="prateleiras" ,["val"]=false,["qual"]=nil}

 --listas de particulas -----------------------------------------------------------------------------------------------------------------------------------------------------------+
 pat_sem = {["tipo"]="particulas sementes",["val"]=false,["qual"]={} }	
 pat_reg = {["tipo"]="particulas regador" ,["val"]=false,["qual"]={} }	
 
 --init de palavras ---------------------------------------------------------------------------------------------------------------------------------------------------------------+
 p1={192,193,193,194,240}
 p2={208,193,192,240}
 p3={208,194,195,209,192,240} 
 p4={210,194,193,241,211,224,240}
 p5={208,224,227,243,211}
 p5={208,224,227,243,211}
 p6={225,226,242}
 p7={244,245,246}
 
 tools   = criar_obj("palavra",0,ls_plv,p1,11,  4)
 pots    = criar_obj("palavra",0,ls_plv,p2,11, 32)
 plants  = criar_obj("palavra",0,ls_plv,p3,11, 60)
 flowers = criar_obj("palavra",0,ls_plv,p4,11, 88)
 price   = criar_obj("palavra",0,ls_plv,p5,17,120)
 buy     = criar_obj("palavra",0,ls_plv,p6,99,118)
 buy_atv = criar_obj("palavra",0,ls_plv,p7,99,118)
 
 --instancias ---------------------------------------------------------------------------------------------------------------------------------------------------------------------+
 
 --cursor .........................................................................................................................................................................+
 mouse = criar_obj("mouse",0)
	
 --botoes .........................................................................................................................................................................+
 bt_loja = criar_obj("botao",1,ls_bts)
 bt_volt = criar_obj("botao",2,ls_bts)
 bt_comp = criar_obj("botao",3,ls_bts)
 bt_dept = criar_obj("botao",4,ls_bts)

 --espacos da lojinha .............................................................................................................................................................+
 for i=1,4 do criar_esps(4) end
 enfileirar_esp(ls_esp[1],11,10)
 enfileirar_esp(ls_esp[2],11,38)
 enfileirar_esp(ls_esp[3],11,66)
 enfileirar_esp(ls_esp[4],11,94)
 
 --atalhos ........................................................................................................................................................................+
 init_atl(6,60)
 
 --prateleiras ....................................................................................................................................................................+
 criar_prateleiras(4)
	
	--objetos funcionais padrao ------------------------------------------------------------------------------------------------------------------------------------------------------+
	regador = criar_obj("item",17,ls_inv.coisas,nil, 50 ,18)

 --[[testes @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@+
 vaso_change = 5
 que_planta  = 9
 aux_x = 10
 for i=1, 4 do
  teste = criar_obj("item",vaso_change,ls_jrd.coisas,nil, 5 ,80)
  vaso_change += 1
  if(vaso_change>8)vaso_change=5
  teste.planta = (criar_obj("item",que_planta)).fases
  que_planta += 1
  teste.x = aux_x
  add(ls_vas_atv,teste)
  aux_x += 20
 end
 
 criar_obj("item",2,ls_inv.coisas,nil, 20 ,10)
 criar_obj("item",3,ls_inv.coisas,nil, 30 ,40)
 criar_obj("item",4,ls_inv.coisas,nil, 60 ,50)
 criar_obj("item",5,ls_inv.coisas,nil, 80 ,50)
 
 ls_atl.atls[1].item = criar_obj("item",5)
 ls_atl.atls[2].item = criar_obj("item",6)
 ls_atl.atls[3].item = criar_obj("item",7)
 ls_atl.atls[4].item = criar_obj("item",15)
 ls_atl.atls[5].item = criar_obj("item",17)
 ls_atl.atls[6].item = criar_obj("item",9)
]]
end

--update ==========================================================================================================================================================================+
function _update()
	mouse:att()
	foreach(ls_bts,function(obj) cool_down(5,obj) end)

 --atualizar particulas
	att_particulas(pat_sem)
 att_particulas(pat_reg)
 --[[
  if(ls_atl.qual)    cu1 = ls_atl.qual.id 
  if(not ls_atl.qual)cu1 = nil
  ]]
 --jogo principal rocha --------------------------------------------------------------------------------------------+	
 if(status == 1)then
  cool_down(5,ls_jrd)
  cool_down(5,ls_atl)
  
  --ir depot .......................................................................................................
  if(ls_atl.show)then
   bt_dept:hover()
   bt_dept:ativa()
  end
  
  --ir loja ........................................................................................................   
  if(not ls_atl.show and not ls_atl.val)then
   bt_loja:hover()
   bt_loja:ativa()
  end
  	
  --colisao atalhos ------------------------------------------------------------------------------------------------------+
  if(ls_atl.show) then
   check_sel_and_mov(ls_atl.atls,ls_atl,"circ")	 
  end
    
 	--colisao jardim -------------------------------------------------------------------------------------------------------+
	 --delay pra comecar a mover
  cool_down(5,ls_jrd)
  if(not ls_atl.show and ls_jrd.wait) then
   check_sel_and_mov(ls_jrd.coisas,ls_jrd,"retg",ls_jrd.val)	 
  end

  --performar atribuicao
  if(ls_atl.show and ls_atl.qual)toggle_atribuir()
  --se o timer contou ja
  if(ls_atl.wait)atribuir()
  
  atl_on_off(mouse.dir_press)	
  
  --regar -------------------------------------------------------------------------------------------------------+
		if(pat_reg.val and not ls_atl.show)then
			if(mouse:toggle(mouse.esq,204,236)) gerar_part(pat_reg, 1, 2, 3, nil)				
		end
		
		--esperando awa -------------------------------------------------------------------------------------------------------+
 	foreach(pat_reg,function(obj) regar(obj) end)
  
  --esperando semente -------------------------------------------------------------------------------------------------------+
 	foreach(pat_sem,function(obj) plantar(obj) end)

 --lojinha rocha ---------------------------------------------------------------------------------------------------+				
 elseif(status == 2)then
 	
  --selecionar loja ................................................................................................+
  for i in all(ls_esp) do
  	foreach(i,function(esp) esp:hover("retg" ) end)
		 check_sel_and_mov(i,ls_esp,"retg")										
  end
    
  --selecionar compra ..............................................................................................+
  if(ls_esp.qual)then
   mouse:tip_set(231,"➡️","")
  	sel_compra(ls_esp.qual,1)			
  end  
  
  --colisao no carrinho ............................................................................................+
  if(not ls_car.val and #ls_car.coisas >0) then
   foreach(ls_car.coisas,function(esp) esp:hover("retg") end)
   check_sel_and_mov(ls_car.coisas,ls_car,"retg")
  end
   
  --remover carrinho ...............................................................................................+
  if(ls_car.qual)then
  	sel_compra(ls_car.qual,2)
   mouse:tip_set(232,"➡️","")
  end
  			
  bt_comp:hover()
  bt_comp:ativa()			
  bt_volt:hover()
  bt_volt:ativa()
	
  if(not ls_esp.qual and not ls_car.qual)mouse:reset()

 --deposito rocha --------------------------------------------------------------------------------------------------+
 elseif(status == 3)then
  cool_down(5,ls_inv)
  cool_down(5,ls_atl)

  grav_depot()
  
  --checar colisao =================================================================================================+
		--atalhos --------------------------------------------------------------------------------------------------------+
  if(ls_atl.show) then
   check_sel_and_mov(ls_atl.atls,ls_atl,"circ")	 
  end
  
		--inventario -----------------------------------------------------------------------------------------------------+
	 --delay pra comecar a mover
		if(not ls_atl.show and ls_inv.wait) then
   check_sel_and_mov(ls_inv.coisas,ls_inv,"retg",ls_inv.val)	 
  end
	
  --performar atribuicao
  if(ls_atl.show and ls_atl.qual)toggle_atribuir()
  --se o timer contou ja
  if(ls_atl.wait)atribuir()
  
  atl_on_off(mouse.dir_press)	
     
  if(ls_atl.show)then
   bt_dept:hover()
   bt_dept:ativa()
  end

 end

end

--draw =============================================================================================================+
function _draw()
 cls()
 --jogo principal --------------------------------------------------------------------------------------------------+
 if(status == 1)then
  bt_loja:des()
  des_jardim()
  
  --particulas -----------------------------------------------------------------------------------------------------+
  des_particulas(pat_sem)
 	des_particulas(pat_reg)
 	
 	--atalhos --------------------------------------------------------------------------------------------------------+	
  des_atl()

 --loljinha --------------------------------------------------------------------------------------------------------+
 elseif(status == 2)then
  des_lojinha()
  des_esps(ls_esp[1])
  des_esps(ls_esp[2])
  des_esps(ls_esp[3])
  des_esps(ls_esp[4])
  des_car()
  tool_tip()
  des_bt_comprar()
  bt_volt:des()
 
 --deposito -------------------------------------------------------------------------------------------------------+
 elseif(status == 3)then
  des_depot()
  des_atl()
 end

 mouse:des()
	if(false) pos_mouse(10)

	if(false) then
	 format(cu1,str1)
	 format(cu2,str2)
	 format(cu3,str3)
	 format(cu4,str4)
	 format(cu5,str5)
	 format(cu6,str6)
	 format(cu7,str7)
	 format(cu8,str8)
	 format(cu9,str9)
	 espacamento =0
	end
	--rect(stat(32),stat(33),stat(32)+7,stat(33)+7,10)
end

function format(que_cu,str,cor)
 str = str or ""
 cor = cor or 5	
 print(str..tostr(que_cu),0,espacamento,8)
 espacamento+=6	
end

-->8
--classes ==========================================================================================================+
function criar_obj(que_classe,subtipo,ls_guardar,ls_aux,xop,yop)
 novo_obj = {
  --atributos ------------------------------------------------------------------------------------------------------+
  cla      = que_classe,
  s        = 0,
  cur_s    = 0,
  x				    = xop or 0,
  y 			    = yop or 0,
  w        = 8,
  h        = 8,
  r        = 1,
  n        = 0,
  xoff     = 0,
  yoff     = 0,
  hoff     = 0,
  woff     = 0,
 	y_vel    = 1,
  movable  = false,
  contble  = false,
  ct       = 0,
  id       = 0,
  ls_gua   = ls_guardar,
  ls_aux   = ls_aux or nil,

  --metodos--------------------------------------------------------------------------------------------------------+
  --mover objeto ..................................................................................................+
  mov = function(self, newx, newy)
   self.x = newx& ~1
   self.y = newy& ~1
  end,
  
  --controlar objeto...............................................................................................+]
  cont = function(self,sair_tela,vel)
   if(btn(⬅️)) self.x -= vel
   if(btn(➡️)) self.x += vel
	 	if(btn(⬆️)) self.y -= vel
	 	if(btn(⬇️)) self.y += vel
	 	
	 	if(sair_tela) n_sai_tela(self) 	
	 end,
	 
	 --desenhar objeto
	 des = function(self,xop,yop)
	 	self.x = xop or self.x  
	 	self.y = yop or self.y
	  pal(self.ct,0)
	 	spr(self.s,self.x,self.y,self.w/8,self.h/8)
			pal()
	 end,
	 
	 --mover com o cursor
	 mov_cur = function(self,contexto,pode_mover)
			if(contexto and self.movable and pode_mover)self:mov((stat(32) - flr(self.w/2)),(stat(33) - flr(self.w/2)))
			n_sai_tela(self)
			return que_botao
	 end,

	 --checa colisao entre algo e 
		--o cursor
  col_mouse =	function(self,tipo)
			if(tipo == "retg")then
				--checar entre direita e esquerda, cim e baixo
				esq =  self.x+self.xoff
				dir = (self.x+self.xoff)+(self.w-self.woff)
				cim =  self.y+self.yoff
				bax = (self.y+self.yoff)+(self.h-self.hoff)
					
				return (stat(32)>=esq and (stat(32)) <= dir) and
       				(stat(33)>=cim and (stat(33)) <= bax)
	 	
			elseif(tipo == "circ")then
				dx   = self.x - stat(32)
				dy   = self.y - stat(33)
				dist = flr(sqrt((dx*dx)+(dy*dy)))
				return dist <= self.r				
				
	 	end
	 
 end	
	}
	
 def_tip(novo_obj,subtipo,ls_guardar) 

 add(ls_guardar,novo_obj)

 return novo_obj
end
-->8
--def_tipos ====================
function def_tip(self,subtipo)

--mouse ========================		 
	if(self.cla == "mouse")then
  self.ativ      = true
 	self.s         = 212
		self.ct        = 1
			
		--esperando ==================
 	self.esq_esper = false
 	self.mei_esper = false
 	self.dir_esper = false
		
		--pressionado ================
 	self.esq_press = false
 	self.mei_press = false
 	self.dir_press = false
		
		--estado atual ======================
 	self.esq = false
 	self.mei = false
 	self.dir = false

		--solto ======================
 	self.esq_solto = false
		self.mei_solto = false
		self.dir_solto = false
		
		--estado =====================
		--self botao?
	function self:get_estado(bt_press)
	 	local estado_atual = stat(34)
			--esquerda ==================
			if(bt_press == 1)	then
				return estado_atual==1
			--meio ======================
			elseif(bt_press == 4) then
				return estado_atual==4
			--direira ===================
			elseif(bt_press == 2)then
				return estado_atual==2
			end
		end
	--resetar mouse ===============
 function self:reset()
	 self.s        = 212
	 self.tool_tip = nil
	 self.h        = 8
	 self.w        = 8	
	 self.ct       = 1
	end
	
	--mudar tool_tip
	function self:tip_set(qual,dir_x,dir_y)
	 self.tool_tip = qual or nil	
 	dir_x,dir_y = dir_x,dir_y

		if(dir_x == "⬅️")then
		 self.xoff = -8		
		elseif(dir_x == "➡️")then
			self.xoff =  8
		else
			self.xoff =  0
		end

		if(dir_y == "⬆️")then
		 self.yoff = -9		
		elseif(dir_y == "⬇️")then
			self.yoff =  9
		else
			self.yoff =  0
		end

	end
 	 
	--desenhar mouse ==============
 function self:des()
  pal(self.ct,0)
  spr(self.s,stat(32),stat(33),self.w/8,self.h/8)
 	if(self.tool_tip)spr(self.tool_tip,stat(32)+mouse.xoff,stat(33)+mouse.yoff)
		pal()

 end
 
 function self:toggle(que_bt,spr_1,spr_2)
 	if(que_bt)then
 	 mouse.s = spr_2
 	 return true
 	end
   mouse.s = spr_1
	 return false
 end
 
 --atualizar mouse =============
 function self:att()
 	--att posicao ================
 	self.x = stat(32)
 	self.y = stat(33)
 	--att posicao ================
		self.esq=self:get_estado(1)
		self.mei=self:get_estado(4)
		self.dir=self:get_estado(2)
		
		--comportamento esquerdo ||||
		--se o mouse esq foi apertado
		if(self.esq)then
			--se ele estava solto
			if(self.esq_solto)then
				--agora nao esta mais
				self.esq_solto=false
			end
			
			--se ele nao estava pressio
			--nado
			if(not self.esq_press)then
		 	--se nao estava esperando
				if(not self.esq_esper) then
		 		--agora esta pressionado
		 		--e esperando
					self.esq_press = true
					self.esq_esper = true
				end
			--se ja estava pressionado
			else
				--agora no esta mais
				self.esq_press = false
			end
			
		--se o mouse esq nao foi
		--apertado
		else
		--se estava pressionado
			if (self.esq_press) then
				--agora nao esta mais
				self.esq_press=false
			end
			
			--se nao esatava solto
			if(not self.esq_solto)then
				--se estava esperando
				if(self.esq_esper)then
					--agora esta solto
					self.esq_solto = true
					--e nao esta mais esperando
     self.esq_esper = false
    end
   --se estava solto
   else
   	--agora nao esta mais
   	self.esq_solto = false
   end
	 end
		
 	--comportamento meio ||||||||
		--se o mouse mei foi apertado
		if(self.mei)then
			--se ele estava solto
			if(self.mei)then
				--agora nao esta mais
				self.mei_solto=false
			end
			
			--se ele nao estava pressio
			--nado
			if(not self.mei_press)then
		 	--se nao estava esperando
				if(not self.mei_esper) then
		 		--agora esta pressionado
		 		--e esperando
					self.mei_press = true
					self.mei_esper = true
				end
			--se ja estava pressionado
			else
				--agora no esta mais
				self.mei_press = false
			end
			
		--se o mouse mei nao foi
		--apertado
		else
		--se estava pressionado
			if (self.mei_press) then
				--agora nao esta mais
				self.mei_press=false
			end
			
			--se nao esatava solto
			if(not self.mei_solto)then
				--se estava esperando
				if(self.mei_esper)then
					--agora esta solto
					self.mei_solto = true
					--e nao esta mais esperando
     self.mei_esper = false
    end
   --se estava solto
   else
   	--agora nao esta mais
   	self.mei_solto = false
   end
	 end
	 
 	--comportamento direita ||||||
		--se o mouse dir foi apertado
		if(self.dir)then
			--se ele estava solto
			if(self.dir)then
				--agora nao esta mais
				self.dir_solto=false
			end
			
			--se ele nao estava pressio
			--nado
			if(not self.dir_press)then
		 	--se nao estava esperando
				if(not self.dir_esper) then
		 		--agora esta pressionado
		 		--e esperando
					self.dir_press = true
					self.dir_esper = true
				end
			--se ja estava pressionado
			else
				--agora no esta mais
				self.dir_press = false
			end
			
		--se o mouse dir nao foi
		--apertado
		else
		--se estava pressionado
			if (self.dir_press) then
				--agora nao esta mais
				self.dir_press=false
			end
			
			--se nao esatava solto
			if(not self.dir_solto)then
				--se estava esperando
				if(self.dir_esper)then
					--agora esta solto
					self.dir_solto = true
					--e nao esta mais esperando
     self.dir_esper = false
    end
   --se estava solto
   else
   	--agora nao esta mais
   	self.dir_solto = false
   end
	 end
	end

--particula ====================
	elseif(self.cla == "particula")then
		self.vx    = rnd(2) - 1
 	self.vy    = 1
		self.x_max = 128
		self.x_mix = 0
		self.w     = 0
		self.h     = 0

 	if(subtipo == 1)then
 		self.cor = 3
		 self.ace = 0
 	elseif(subtipo == 2)then
 		self.cor = 12
		 self.ace = 0.2
 	end

		function self:att()			
			self.x  +=	self.vx
			self.y  += flr(self.vy)
  	self.vy += self.ace
  	
			if(self.x>self.x_max)then
				self.x = self.x_max
				
			elseif(self.x<self.x_min)then
				self.x  = self.x_min
				self.vx = -self.vx
			end
			
			if(saiu(self))then
				pat_sem.val = false
				self:del()
			end
		end
		
		function self:des()
	  pset(self.x,self.y,self.cor)
	 end
	 
	 function self:del()
			if(self)then
		 del(self.ls_gua, self)
	  self = nil
			end
	 end
	
--botao ========================		 
	elseif(self.cla == "botao")then
		self.timer = 0
		self.wait  = false
		self.val   = true
		 
		--lojinha
		if(subtipo == 1)then
 		self.tip       = 1
			self.x		       = 1
			self.y         = 113
	  self.w,self.h  = 16,16
	  self.tam       = 2
	  self.s,self.sr = 14,14
		 self.sp        = 46
		 self.ct        = 1
		 
	 --voltar
		elseif(subtipo == 2)then
			self.tip       = 2
			self.x		       = 1
			self.y         = 113			
	  self.w,self.h  = 16,16
	  self.tam       = 2
	  self.s,self.sr = 12,12
		 self.sp        = 44
		 self.ct        = 0

		--comprar
		elseif(subtipo == 3)then
 		self.tip            = 3
			self.x	            	= 97
			self.y              = 116 		
			self.w              = 18
	  self.h              = 8
	  self.cor1,self.cor3 = 5,5
	  self.cor2           = 10

	 --depot
		elseif(subtipo == 4)then
 		self.tip       = 4
			self.x,self.y  = 57,57		
			self.w,self.h  = 16,16
	  self.tam       = 2
   self.s,self.sr = 40,40
		 self.sp        = 42
	  self.ct        = 1
	  
		elseif(subtipo == 5)then
 		self.tip       = 5
			self.x,self.y  = 80,113		
			self.w,self.h  = 8,8
	  self.tam       = 1
   self.s,self.sr = 236,236
		 self.sp        = 237
	 end
	 
	 --metodos de botoes
	 
	 --ativar botao
		function self:ativa()
			--teve colisao
			if(self:col_mouse("retg") and not(mouse.eq_press))then
				--mouse esquerdo pressionado			
				if(mouse.esq_press and self.wait)then						
					--funcoes ===================
					--ir lojinha
					if(self.tip == 1)then
						status  = 2		
		   	mouse:reset()
			  			 
					--voltar jogo principal
					elseif(self.tip == 2)then
						status = 1
						 	 
					--comprar
					elseif(self.tip == 3)then		
						comprar()				
								 
					--ir depot
					elseif(self.tip == 4 and not ls_atl.val)then
						if(status==1)then
							status      = 3
							bt_dept.s   = 12
							bt_dept.sr  = 12
							bt_dept.sp  = 44
							self.ct     = 0
							ls_inv.wait = false
							
						elseif(status==3)then
							bt_dept.s   = 40
							bt_dept.sr  = 40
							bt_dept.sp  = 42
							status      = 1
							ls_atl.val  = false
							self.ct     = 1
						 ls_jrd.wait = false
      	ls_atl.qual = nil      	
						end					
 					ls_atl.show = false
						foreach(ls_bts,function(obj) obj.wait = false end)

						return
					end
				end
			end
		end
		
		function self:hover()
			
			if(self:col_mouse("retg") and self.wait)then

				if(self.tip == 3 and count(ls_car.coisas)>0)then				
				 self.cor1 =	self.cor2
				else
				 self.cor1 =	self.cor3
					self.s    = self.sp
				end
	
			else
			
			 self.cor1 =	self.cor3
				self.s = self.sr	
			
			end
		end
	
	elseif(self.cla == "espaco")then
		self.w,self.h = 18,18
 	self.tam      = 16
 	--espaco da loja
 	if(subtipo == 1)then
 	 self.cor1,self.cor3 = 1,1
	 	self.cor2   = 7
	  self.cur_s = 0
		--carinho	
 	elseif(subtipo == 2)then
			self.cor1,self.cor3 = 1,1
	 	self.cor2 = 8
		--atalho
 	elseif(subtipo == 3)then
 		self.x,self.y = 64,64
	 	self.w,self.h = 16,16
		end

		function self:hover(tip_col)

			if(self:col_mouse(tip_col))then
				 self.cor1 = self.cor2
			else
				 self.cor1 = self.cor3
				 self.qual = nil
				 self.val  = false
			end
			
		end
		
	elseif(self.cla == "prateleira")then			
			self.h = 1
			self.w = 80

	elseif(self.cla == "item")then				
		self.w  = 16
		self.h  = 16
		self.movable = true
		--pa
		if(subtipo == 1)then
 		self.tip  = 1
		 self.val  = 0
		 self.nome = "unknow"
		 self.s    = 2
		 self.xoff = 2
			self.yoff = 2
 	 self.woff = 5
 		self.hoff = 5
	 	self.cur_s = 214

		--regador
	 elseif(subtipo == 2)then
 		self.tip  = 2
		 self.val  = 300
		 self.nome = "basket"
		 self.s    = 4
		 self.xoff = 0
			self.yoff = 6
 	 self.woff = 1
	 	self.hoff = 8
	  self.ct   = 1
	 	self.cur_s = 215

		--borrifador
	 elseif(subtipo == 3)then
 		self.tip  = 3
	  self.val  = 400
		 self.nome = "pesticide"
		 self.s    = 6
		 self.xoff = 3
			self.yoff = 1
 	 self.woff = 7
	 	self.hoff = 4
	 	self.cur_s = 229

		--fertilizante	 	
	 elseif(subtipo == 4)then
 	 self.tip  = 4
	  self.val  = 500
		 self.nome = "fertilizer"
		 self.s    = 8
		 self.xoff = 3
			self.yoff = 1
 	 self.woff = 7
	 	self.hoff = 4
	 	self.cur_s = 216
	 	
	 --vasos rocha
	 elseif(range(subtipo,5,8))then
	 	self.estagio = 1
			self.colher  = false
			self.saturac = 0
			self.cur_s = 230
			
  	function self:des_planta()
  		local aux = self.planta.wh[self.estagio][1]
  		if(aux > 1)then
  		 spr(self.planta[self.estagio],self.x          ,self.yp-(self.planta.wh[self.estagio][2]*8),self.planta.wh[self.estagio][1],self.planta.wh[self.estagio][2])
  		else
  		 spr(self.planta[self.estagio],self.x+self.xesp,self.yp-(self.planta.wh[self.estagio][2]*8),self.planta.wh[self.estagio][1],self.planta.wh[self.estagio][2])
  		end
  		
  	end
  	
  	function self:des(xop,yop)
  		self.x = xop or self.x
		 	self.y = yop or self.y
		 	--cordenadas onde planat fica no vaso		 	
		 	self.xp = self.x+self.xpoff
		 	self.yp = self.y+self.ypoff

		  pal(self.ct,0)
		 	spr(self.s,self.x,self.y,self.w/8,self.h/8)
				pal()
				
				if(self.planta)then
					self:des_planta()
				end			
  	end
			
			--vaso1
		 if(subtipo == 5)then
	 	 self.tip  = 5
			 self.val  = 500
			 self.nome = "flowerpot 1"
			 self.s    = 32
			 self.xoff = 2
				self.yoff = 5
	 	 self.woff = 5
		 	self.hoff = 8
		  self.ct   = 1

		  --cordenadas da plnat no vaso
		  self.xpoff = 8 
		  self.xesp  = 4
		  self.ypoff = 8
		
			--vaso2
		 elseif(subtipo == 6)then
		  self.tip  = 6
			 self.val  = 500
			 self.nome = "flowerpot 2"
			 self.s    = 34
			 self.xoff = 2
				self.yoff = 5
	 	 self.woff = 5
		 	self.hoff = 7
		  self.ct   = 1
		 
		  self.xpoff = 8
		  self.xesp  = 4
		  self.ypoff = 7
		 			 
			--vaso3
		 elseif(subtipo == 7)then
		  self.tip  = 7
			 self.val  = 600
			 self.nome = "flowerpot 3"
			 self.s    = 36	
			 self.xoff = 3
				self.yoff = 2
	 	 self.woff = 7
		 	self.hoff = 5
		  self.ct   = 2
		 	
		  self.xpoff = 8
		  self.xesp  = 4
		  self.ypoff = 5
		 		
			--vaso4
		 elseif(subtipo == 8)then
		  self.tip  = 8
			 self.val  = 600
			 self.nome = "flowerpot 4"
			 self.s    = 38
			 self.xoff = 1
				self.yoff = 2
	 	 self.woff = 3
		 	self.hoff = 5
		  self.ct   = 2
		 
		  self.xpoff = 8
		  self.xesp  = 4
		  self.ypoff = 5
		  
	 	end	
		--planta1
	 elseif(range(subtipo,9,18))then
		 self.s    = 10
		 self.ct   = 1
		 self.xoff = 2
			self.yoff = 2
 	 self.woff = 5
	 	self.hoff = 5
	 	self.cur_s = 249

		 if(subtipo == 9)then
		  self.tip  = 9
			 self.val  = 400
			 self.nome = "tomato"
		 	self.fases= {70   ,71   ,87   ,85   ,72   ,104 ,
           wh = {{1,1},{1,1},{1,2},{2,2},{2,2},{2,2}} }
		 		 
			--planta2
		 elseif(subtipo == 10)then
		  self.tip  = 10
		  self.val  = 500
			 self.nome = "bear_pawn"		
		 	self.fases= {64   ,65   ,66   ,67   ,68   ,74  , 76  ,
           wh = {{1,1},{1,1},{1,1},{1,1},{2,1},{2,2},{2,2}} }		 					 
			  	
			--planta3
		 elseif(subtipo == 11)then
		  self.tip  = 11
		  self.val  = 600
			 self.nome = "pumpkin"
		 	self.fases= {96   ,97   ,114  ,115  ,117  ,168  ,136  ,
           wh = {{1,1},{1,1},{1,1},{2,1},{2,1},{2,2},{2,2}} }		 					 
			  				 		 	
		 --planta4
		 elseif(subtipo == 12)then
		  self.tip  = 12
		  self.val  = 1000
			 self.nome = "pegaxi"		
 	 	self.fases= {96   ,97   ,114  ,115  ,117  ,106  ,108  ,
           wh = {{1,1},{1,1},{1,1},{2,1},{2,1},{2,2},{2,2}}} 					 
  				 		 			  	
		 --planta5
		 elseif(subtipo == 13)then
		  self.tip  = 13
		  self.val  = 500
			 self.nome = "sunflower"
			 self.fases= {96   ,80   ,81   ,82   ,83   ,84   ,
           wh = {{1,1},{1,1},{1,1},{1,2},{1,2},{1,2}}} 					 	 	
		
		 --planta6
		 elseif(subtipo == 14)then
		  self.tip  = 14
		  self.val  = 350
			 self.nome = "sword"		 	
			 self.fases= {64   ,112  ,113   ,130 ,132  ,134  ,
           wh = {{1,1},{1,1},{1,1},{2,1},{2,2},{2,2}}} 					 	 	
		 --planta7
		 elseif(subtipo == 15)then
		  self.tip  = 15
		  self.val  = 600
			 self.nome = "rose"
			 self.fases= {70   ,176  ,177  ,162  ,163  ,164  ,165  ,
           wh = {{1,1},{1,1},{1,1},{1,2},{1,2},{1,2},{1,2}}} 			 

		 --planta8
		 elseif(subtipo == 16)then
		  self.tip  = 16
		  self.val  = 1000
			 self.nome = "dandelion"
			 self.fases= {70   ,128  ,129  ,146  ,138  ,140  ,
           wh = {{1,1},{1,1},{1,1},{1,2},{2,2},{2,2}}} 			 
		
			--regador
		 elseif(subtipo == 17)then
	 	 self.tip  = 17
		  self.val  = 500
			 self.nome = "watering can"
			 self.s    = 204
			 self.s2   = 236
			 self.s3   = 204
			 self.xoff = 3
				self.yoff = 1
	 	 self.woff = 7
		 	self.hoff = 4
		 	self.cur_s = 248

		 end 
		end
	
	--palavra	
	elseif(self.cla == "palavra")then				
  self.w    = count(self.ls_aux)
 	self.h    = 4
	 self.cor1 = 5
		self.cor2 = 5
 	function self:des()
			local aux = 0
			for i in all(self.ls_aux)do
					spr(i,self.x+aux,self.y)
					aux +=5
			end
		end
			
	end
	
end

-->8
--colisor e utilitrios =========
--nao deixa um objeto sair
--da tela
function n_sai_tela(oque)
	if(oque != nil)then
		esq = oque.x+oque.xoff
		cim = oque.y+oque.yoff
		dir = esq+oque.w-oque.woff
		bax = cim+oque.h-oque.hoff
	
		if(esq <   0) oque.x = -oque.xoff
		if(cim <   0) oque.y = -oque.yoff
 	if(dir > 127) oque.x = oque.x+(127-dir)
 	if(bax > 127) oque.y = oque.y+(127-bax)-1
	end
end

--saiu da tela
function saiu(oque)
	if(oque != nil)then
		esq = oque.x+oque.xoff
		cim = oque.y+oque.yoff
		dir = esq+oque.w-oque.woff
		bax = cim+oque.h-oque.hoff
			
		if(esq < 0) return true
		if(cim < 0) return true
 	if(dir > 127) return true
 	if(bax > 127) return true
 	return false
	end
end

--checa colisao entre dois retangulos
function col_2ret(q1,q2)
	esq_1 = q1.x+q1.xoff
	cim_1 = q1.y+q1.yoff
	dir_1 = esq_1+q1.w-q1.woff
	bax_1 = cim_1+q1.h-q1.hoff
	
	esq_2 = q2.x+q2.xoff
	cim_2 = q2.y+q2.yoff
	dir_2 = esq_2+q2.w-q2.woff
	bax_2 = cim_2+q2.h-q2.hoff

	--checar entre direita e esquerda
	if(esq_1 < dir_2 and dir_1 > esq_2)then
  if(cim_1 < bax_2 and bax_1 > cim_2)then
			return true
		end
	end

	return false	
	
end


--colisao de dois circulos
function col_circ(q1,q2)
	dx   = q1.x - q2.x
	dy   = q1.y - q2.y
	dist = sqrt((dx*dx)+(dy*dy))
	if(dist <= (q1.r+q2.r))then
		return true
	end
	
	return false
	
end

--colisa de um circulo e 1 ponto
function col_circ_pt(cic,pt)
	dx   = cic.x - pt.x
	dy   = cic.y - pt.y
	dist = flr(sqrt((dx*dx)+(dy*dy)))
	if(dist <= (cic.r))then
		return true
	end
	
	return false
	
end

--retorna o obejto selecionado
--em uma lista
function get_obj_by_col_mos(lista,tipo)
	
	for qual in all(lista)do
		
		if(qual:col_mouse(tipo))return qual
				
	end	

end

function get_obj_by_col_retg(ls_oque_1,oque_2)
	
	for qual in all(ls_oque_1)do
		col = col_2ret(qual,oque_2)		if(col)return qual
		if(col)return qual
	end	
	return nil
end

--checa a selecao de objetos
--em uma lista
--se um deles ja estiver sido 
--nao  checado
function check_sel_and_mov(qual_ls,controle,tipo,pode_mover)
 pode_mover = pode_mover or false

 --se tem alguem selecionado
	if(controle.qual)then
		if(not controle.qual:mov_cur(mouse.esq,pode_mover) and not controle.qual:col_mouse(tipo)) controle.qual = nil
  if(controle.qual and stat(34)==3)then
   add(qual_ls,del(qual_ls,controle.qual))
  end
	--se nao tem ninguem selecionado
	else
		controle.qual = get_obj_by_col_mos(qual_ls,tipo) 
	end
	
end

--desenhar vertice
function des_vertices(x,y,w,h,cor)

 pset(x    ,y    ,cor)
 pset(x+w-1,y    ,cor)
 pset(x    ,y+h-1,cor)
 pset(x+w-1,y+h-1,cor)

end

--retorna as chaves de uma tabela
function get_keys(qual_ls)
	keys = {}
	for i,j in pairs(qual_ls)do
		add(keys,i)
	end
	return keys
end

--exibe x y do mouse
function pos_mouse(cor)
		print("("..stat(32)..","..stat(33)..")",100,120,cor)
end

--apaga uma lista
function del_ls(qual_ls)
	for i in all(qual_ls)do
		del(qual_ls,i)
	end
end

--particulas
function des_particulas(que_ls)
	foreach(que_ls,function(p) p:des() end)
end

--atualizar prticulas
function att_particulas(que_ls)

 for p in all(que_ls) do
 	p:att()
 end
 
end

function gerar_part(que_pat_ls, quantas, tip, ampx, item)
 tip = tip or 1
 for i=1, quantas do
		nova = criar_obj("particula",tip,que_pat_ls,item)
		nova.x     = stat(32)+1
		nova.y     = stat(33)+13
		nova.x_max = nova.x+ampx
		nova.x_min = nova.x-ampx
	end
end

function range(val,⬅️,➡️)
	if(val >= ⬅️ and val <= ➡️)return true
	return false
end

function cool_down(tempo,context)

	if context.val and not context.wait then

		if(context.timer>=tempo)then
		 context.wait  = true
  	context.timer = 0
 	else		
 		context.timer += 1
 	end
		
	end
	
end
-->8
--loljinha =====================
function	des_lojinha()
 --base
	rect(8,2,119,114,5)
	line(92,114,118,114,0)
	--compartimentos			
	rect(37,7,91,28,5)
	rect(32,35,91,55,5)
	rect(42,63,91,83,5)
	rect(47,91,91,114,5)
	
	--linhas do lado labels
	rect(35,30,91,32,5)
	rect(35,31,90,32,0)
	
	rect(45,58,91,60,5)
	rect(45,59,90,60,0)

	rect(50,86,91,88,5)
	rect(50,87,90,88,0)
 
 --tools
 rect(8,2,37,28,5)
 rectfill(9,3,36,27,0)
 rectfill(8,28,91,29,0)
 
 --pots
	local addy = 28
 rect(8,2+addy,32,28+addy,5)
 rectfill(9,36,90,55,0)
 rectfill(8,56,91,57,0)
 
 --plants
 addy +=28
 rect(8,2+addy,42,28+addy,5)
 rectfill(9,64,90,83,0)
 rectfill(8,84,91,85,0)
 
 --flowers
 addy +=28
 rect(8,2+addy,47,28+addy,5)
 rectfill(9,92,90,113,0)
	rectfill(9,112,90,113,0)
	
	--do lado dos labels			
	rect(38,2,39,6,0)
	line(37,8,37,9,0)
	line(32,36,32,37,0)
	line(42,64,42,65,0)
	line(47,92,47,93,0)
	
	--botao de comprar
	rect(92,114,119,126,5)
	rectfill(92,114,118,125,0)
	des_vertices(95,115,22,10,5)
	
	--carrinho de compra
	local y=0
	for i=1,4 do
		rect(95,7+y,116,28+y,5)
		des_vertices(98,10+y,16,16,5)
		y+=28
	end
	
	--precos
 rect(14,117,91,126,5)
 rectfill(15,118,90,125,0)
 rect(14,117,66,126,5)
 
 tools:des()
	pots:des()
 plants:des()
 flowers:des()
 
end

--cria vitrines
function criar_esps(quantos)
	linha ={}

	for i=1,quantos do      
  aux      = criar_obj("espaco",1)
		aux.item = criar_obj("item"  ,aux_tipo)
		add(linha,aux)
		aux_tipo+=1		
	end	
	add(ls_esp,linha)

end

--enfileira as vitrines
function enfileirar_esp(qual,ondex,ondey)

	for i in all(qual)do
		i.x = ondex
		i.item.x = i.x+1
		i.y = ondey
		i.item.y = i.y+1
		ondex += 20
	end	

end

--desenha todas as vitrines
function des_esps(qual_linha)

	for i in all(qual_linha)do
		des_esp(i)
	end

end

--desenha uma vitrine
function des_esp(i)

	rect(i.x,i.y,i.x+i.w-1,i.y+i.h-1,i.cor1)	
	rectfill(i.x+1,i.y+1,(i.x+i.w-1)-1,(i.y+i.h-1)-1,0)	
 i.item:des(i.x+1,i.y+1)
 des_vertices(i.x+1,i.y+1,i.w-2,i.h-2,i.cor1)

end

--seleciona produto
--e envia para o carrinho rocha
function sel_compra(qual,op)

	if(mouse.esq_press and qual:col_mouse("retg"))then
		--adiciona ao carrinho
		if(op==1)then
			if(count(ls_car.coisas)<4)then
		  new_car      = criar_obj("espaco",2,ls_car.coisas)
				new_car.item = criar_obj("item",qual.item.tip)
				ls_car.total += qual.item.val
			end
		--remove do carrinho
		elseif(op==2)then
			if(count(ls_car.coisas)<=4)then
				ls_car.total -= qual.item.val
			 del(ls_car.coisas,qual)
			 ls_car.qual = nil
			 return true
			end					
		end
	end		
	
end

--desenha o carrinho de compras
function des_car()

	if(count(ls_car.coisas)>0)then
		 
		for i=1,count(ls_car.coisas) do
		 ls_car.coisas[i].x=97
			if(i==1)then
				ls_car.coisas[i].y=9
			end
			if(i==2)then
				ls_car.coisas[i].y=37
			end
			if(i==3)then
				ls_car.coisas[i].y=65
			end
			if(i==4)then
				ls_car.coisas[i].y=93
			end
			des_esp(ls_car.coisas[i])
		end
		
	end
	
end

function des_bt_comprar()
	rect(bt_comp.x,bt_comp.y,bt_comp.x+bt_comp.w-1,bt_comp.y+bt_comp.h-1,bt_comp.cor1)	
	if(not bt_comp:col_mouse("retg"))then
			buy:des()
	else
		if(count(ls_car.coisas)>0)then
		 buy_atv:des()
		else
			buy:des()
		end
	end
end

function tool_tip()
	--mostrar preco ao passar mouse
	if(ls_esp.val)then
		if(ls_esp.qual != nil)then
			auxtip = ls_esp.qual.item.tip
			if(auxtip >=9 and auxtip <=16)then
				print("seeds",17,120,6)			
			else
				print(ls_esp.qual.item.nome,17,120,6)
			end
			local cor = 6
			if(ls_esp.qual.item.val > saldo) cor = 8
	  print(ls_esp.qual.item.val,69,120,cor)
		end
	
	elseif(bt_comp:col_mouse("retg") and ls_car.total!=0 )then
			print("total",17,120,10)
	  print(ls_car.total,69,120,10)
	
	--mostrar preco ao passar mouse no carrinho
	elseif(ls_car.val)then
	
		if(ls_car.qual != nil)then			
			print(ls_car.qual.item.nome,17,120,6)
	  print(ls_car.qual.item.val,69,120,6)
 	end

	--mostrar saldo 	
	else
		print("money",17,120,13)
		print(saldo,69,120,13)
	end
end

function comprar()
	if(ls_car.total<=saldo)then
		saldo -= ls_car.total	
		ls_car.total	= 0
		
  add_varios_itens(ls_car.coisas,2)
  del_ls(ls_car.coisas)
		return true
	end
	
	return false
	
end
-->8
--inventario ===================
function des_inv()
	if(status==3)then
		foreach(ls_inv.coisas,function(obj) obj:des() end)
	else
		foreach(ls_jrd.coisas,function(obj) obj:des() end)
	end
end

function espalhar_pos(ls_doque)

	for i in all(ls_doque)do
		i.x = rnd(112)
	 i.y = rnd(112)
	 n_sai_tela(i)
	end

end

function add_um_item(qual,onde)
	
	if(status == 2)def_pos(qual)
	if(onde == 1) add(ls_jrd.coisas,qual)
 if(onde == 2)	add(ls_inv.coisas,qual)
 
end

function add_varios_itens(qual_ls,onde)
	
	for i in all(qual_ls)do
		add_um_item(i.item,onde)
	end

end

function print_inv()
	yplus = 1
	if(count(ls_inv.coisas)>0) then
	 yplus += 6
	 for i in all(ls_inv.coisas)do
 	 print(i.nome,1,yplus,15)
 	 yplus += 6
	 end
	end
end


-->8
--menu_de_atalho=================
function init_atl(quantos,ang_inc)	
	angulo  = 0
	ang_inc = ang_inc or 45
	quantos = quantos or 4
	for i=1,quantos do
  	new_atl      =	criar_obj("espaco",3,ls_atl.atls)  
 	 new_atl.x    =	new_atl.x - 25 * sin(angulo/360)
 	 new_atl.y    =	new_atl.y - 25 * cos(angulo/360) 	 
 	 new_atl.item = nil
			new_atl.cor1 = 1 	
			new_atl.cor2 = 7
			new_atl.cor3 = 1
			new_atl.id   = i
			new_atl.r    = 8.5
	 	angulo      += ang_inc
	end
end

function des_atl()

	if(ls_atl.show)then
		for i in all(ls_atl.atls)do
		 ovalfill(i.x-9, i.y-9,i.x+10,i.y+10,0)
   ovalfill(i.x-8, i.y-8,i.x+9 ,i.y+9 ,0)
   oval(i.x-8, i.y-8,i.x+9,i.y+9,i.cor1)

			if(i.item !=nil)then
			 i.item:des(i.x-7,i.y-7)
			end
 		i:hover("circ")
		end  	
		
  bt_dept:des()
	end

end

--mostrar-ocultar atalhos
function atl_on_off(context)

	if(context)then
		ls_atl.show = not ls_atl.show 
		
		if(ls_atl.show)then 
			mouse:reset()

			ls_jrd.val   = true
			ls_inv.val   = true
			
			ls_jrd.qual  = nil
			ls_inv.qual  = nil
			
			ls_atl.val   = false
			ls_atl.wait  = false
			ls_atl.timer = 0
			
			pat_reg.val  = false
			
			foreach(ls_bts,function(obj) obj.wait = false end)

		end
		
	end	
		
end

function toggle_atribuir()
	
	if(mouse.esq_press)then	
  --oculta os atalhos
	 atl_on_off(true)
	 --poe em contexto de atribuicao
		ls_atl.val  = true
		--desativa o movimento do jardim e inventario
		ls_jrd.val,ls_inv.val = false,false				
		
		if(status == 3)then
			if(ls_atl.qual and ls_atl.qual.item)then
	   mouse:tip_set(ls_atl.qual.item.cur_s,"⬅️","⬆️")
	 	else
	   mouse:tip_set(217,"⬅️","⬆️")
	 	end
	 else
	 	if(ls_atl.qual and ls_atl.qual.item and range(ls_atl.qual.item.tip,5,8))then
	   mouse:tip_set(ls_atl.qual.item.cur_s,"⬅️","⬆️")
	 	end
	 end
	end								
end

function atribuir()
	--o atalho selecionado
	-- ja tem um item?
	-- se ele ja tiver efetuamos
	-- uma troca com o jardim/inv
	if(ls_atl.qual)then
		--exclusivo depot ------------------------------------------------------------
		if(status == 3)then				
	 	if(ls_atl.qual.item)then
	 	 if(atl_para_container(mouse.esq,ls_inv,true)) atl_on_off(true)
			else
   	if(container_para_atl(mouse.esq,ls_inv)) atl_on_off(true)
			end	
			
		--exclusivo jardim rocha  ------------------------------------------------------------
		else
 		--so e possivel por vasos no jardim
			if(ls_atl.qual.item and range(ls_atl.qual.item.tip,5,8))then
	 		if(atl_para_container(mouse.esq,ls_jrd))atl_on_off(true)
			else
	 		--so e possivel guardar vasos sem planta
 			if(ls_jrd.qual and ls_jrd.item  and range(ls_jrd.qual.item.tip,5,8) and not ls_jrd.qual.planta)then
	 			if(container_para_atl(mouse.esq,ls_jrd)) atl_on_off(true)
	 		elseif(ls_atl.qual.item)then
	 		 funcionalidades()
				end
				
			end	
			
		end

	end

end

--[[
	troca de luagres o item do atalho
	atua com algum do inventario que
	for clicado	
]]
function atl_para_container(context,qual_container,permutavel)
	permutavel = permutavel or false	
	if(qual_container.qual and permutavel)then
	 mouse:tip_set(ls_atl.qual.item and 233 or 217,"⬅️","⬆️")		
 else
	 mouse:tip_set(ls_atl.qual.item.cur_s,"⬅️","⬆️")
 end
	 
	if(context)then

		--se algo do container
		--nao esta sendo selecionado
		--poe na posicao do cursor ajustado
		if((qual_container.qual and not permutavel) or not qual_container.qual)then
			ls_atl.qual.item:mov(stat(32)-11,stat(33)-16)	
	 	--aficiona ao container
			add(qual_container.coisas,ls_atl.qual.item)
 		--esvazia o atalho
 	 ls_atl.qual.item = nil
   
  --se algo do container
		--esta sendo selecionado
		--permuta esse "algo" com
		--o item do atalho
		 qual_container.val  = true
   qual_container.wait = false
   ls_atl.qual = nil
   mouse:reset()
 		return false
		else
		 --poe o item do atalho na mesma posicao do item selecionado
			ls_atl.qual.item:mov(qual_container.qual.x,qual_container.qual.y-2)	
			--add o item do atalho no container
			add(qual_container.coisas,ls_atl.qual.item)
 		--remove o item selecionado do container e passa pro atalho
 		ls_atl.qual.item = del(qual_container.coisas,qual_container.qual)
			qual_container.val  = true
   qual_container.wait = false
		 return true
		end
	end
	return false
end

function container_para_atl(context,qual_container)
	--se algo do container esta sendo selecionado		

	if(qual_container.qual)then
		if(context)then
			local para_atl = qual_container.qual
			ls_atl.qual.item =	del(qual_container.coisas,para_atl)

 		ls_atl.qual         = nil
			ls_atl.val          = false
			qual_container.val  = true
	  qual_container.wait = false

	  return true
		end
	end
	return false
end
-->8
--deposito======================
function des_depot()
 --base
	rect(107,3,119,115,1)
	rect(8,3,107,115,4)
	--pesinhos
	rect(16,118,28,122,1)
	rect(8,118,16,122,4)
	rect(107,118,119,122,1)
	rect(99,118,107,122,4)
	line(8,118,119,118,0)
	
	--pregos frente
	local aux_1,aux_2 = 6,0
 for i=1,3 do
	des_vertices(11,aux_1,94,26,1)
		aux_1 += 53
	end
	--pregos laterais
	aux_1 = 11
	for i=1,4 do
		des_vertices(109,aux_1,9,20,1)
		aux_1 += 26
	end
		
 --prateleiras
	aux_1 = 11
	aux_2 = 32
	for i=1,4 do
		rect(16,aux_1,28,aux_2,1)
		rect(16,aux_1,95,aux_2,4)
		aux_1+= 24
		aux_2+= 24
	end
	
	des_prateleiras(16,32,24)
	des_inv()
end

function des_prateleiras(x_init,y_init,y_esp) 

	aux_y = y_init
	for i in all(ls_prt)do
		i.x  = x_init
	 i.y  = aux_y
  rect(i.x,i.y,i.x+i.w-1,i.y+i.h-1,4)
		aux_y += y_esp
	end
	
end

function criar_prateleiras(quantas)
	for i=1, quantas do
		criar_obj("prateleira",0,ls_prt)
	end	
end

function grav_depot()

	for i in all(ls_inv.coisas) do
		it={
			x = i.x+i.xoff,
			y = i.y+14,
			h = 1,
			w = i.woff,
			xoff = 0,
			yoff = 0,
			woff = 0,
			hoff = 0,	
		}		
		if(
			not	col_2ret(it,ls_prt[1])and
			not	col_2ret(it,ls_prt[2])and
			not	col_2ret(it,ls_prt[3])and
			not	col_2ret(it,ls_prt[4])
		)then
			i.y+=grav
			n_sai_tela(i)	
  else

			i.y = flr(i.y)
		end	
	end

end

function def_pos(i)
		i.x = flr(rnd(80)) + 16 

		if(i.tip <=4)then
			i.y = 10
		elseif(i.tip<=8)then
			i.y = 34
		else
			i.y = 58
		end

end
-->8
--jardim =======================
function des_jardim()
 des_inv()
end

function funcionalidades()
	local aux_tipo = ls_atl.qual.item.tip
 --garantido chegar aqui com um item
 if(range(aux_tipo,9,16))then
  mouse.s     = 228
 	if(mouse.esq)then
	  nova_sem    = gerar_part(pat_sem,1,1,3,ls_atl.qual.item)
			pat_sem.val = true
			ls_atl.qual.item = nil
			ls_atl.qual = nil
			mouse:reset()

		end
	elseif(aux_tipo == 17)then
		mouse.w,mouse.h = 16,16
		pat_reg.val = true

	end
		
end

function plantar(o_que)
	
	qual_vaso = get_obj_by_col_retg(ls_jrd.coisas,o_que)

	if(qual_vaso)then
		add(ls_vas_atv,qual_vaso)
		qual_vaso.planta  = o_que.ls_aux.fases
 	qual_vaso.estagio = 1
  o_que:del()
 	pat_sem.val = false
 	mouse:reset()
 end
 
end

function regar(o_que)

	qual_vaso = get_obj_by_col_retg(ls_jrd.coisas,o_que)

	if(qual_vaso)then
 	qual_vaso.saturac += 0.5
  o_que:del()
  if(qual_vaso.saturac > 1)then
  	avancar_fase(qual_vaso)
   qual_vaso.saturac = 0
  end
 end
	
  
end

function avancar_fases()
	if(status==1 and not ls_atl.show)then
		for i in all(ls_vas_atv)do
			avancar_fase(i)		
		end
	end
end

function avancar_fase(o_que)
 if(not o_que.planta) return
	local inc = 1 --flr(rnd(100))
	o_que.estagio+= inc%2
 if(o_que.estagio >#o_que.planta) o_que.estagio = #o_que.planta
	if(o_que.estagio==#o_que.planta) o_que.colher  = true	
end


__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000880088888800880000000000000000000005577777000000000004224000000000000000000000000000000000000000000000000000000
00dddd50000000000822888888882280000000000000000000005566666000000000049119400000000066666660000000000000000000000550000000000000
00d776650000000000288800008882000000000000000000000000d666d00000000002499420e000000611111116600000000000000000000555555555555500
00d76dd650000000008822000028880000000000000000000000055ddd00000000000022220e0000006111111161150000000500000000000051111111111500
00d6d65d00000000088828800822888000000000000000000000560dd0000000000000eeee2ee00000f1111111f1150000005555555000000051551551551500
0056d550000000000880082288800880440000000000004400006060060000000000044444400000000fffffff11150000055555555500000051111111111500
00056d0d000000000880002888000880404000000000040400000700006000000000e444111e000000d1111111d1150000005555555500000051155155115000
00005000d000000008800088820008802402222222222042000007bbbb60000000044ee13314400000d1bb1bb1d1150000000500001500000051111111115000
00000000060000000880088822800880029111111111192000007333333d00000002441bb314200000611bbb1161150000000000011100000055555555550000
000000000062440008882280088288800429999999999240000733b33b33d00000024413b1442000006111311161150000001111111000000050000000000000
00000000002002000088820000228800024224422442242000063333bbb3d0000002213114422000006111311161150000001111110000000055555555555000
000000000040200000288800008882000024422442244200000063333b3d00000000211222220000006111111161150000000000000000000005500005500000
000000000042000008228888888822800002222222222000000006666dd00000000002222220000000066666666dd00000000000000000000005500005500000
00000000000000000880088888800880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000111111111100000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000001444466444410000000000000000000770000000000000
0000000000000000000000000000000000000dddddd00000000dddddddddd0000011111111111100011111111111111000000000000000000777777777777700
000000000000000000000000000000000000d122221d000000d1111111111d000114444664444110019999977999991000000700000000000071111111111700
00000000000000000002444444442000000061222216000000d1122222211d000144444664444410011111177111111000007777777000000071771771771700
00224444444422000021111111111200000016666661000000612222222216000144444664444410011111111111111000077777777700000071111111111700
00211111111112000041414121411400000001111110000000166666666661000144444664444410011122222222111000007777777700000071177177117000
0041414121411400004112141214140000000d1111d00000000d11111111d0000111111661111110011122222222111000000700005700000071111111117000
00411214121414000091214141411900000066dddddd00000066dddddddddd000141416666141410019191777719191000000000055500000077777777770000
00912141414119000009999999999000000d66dddd6dd0000d66d6dd6ddd6dd00141416116141410019191711719191000005555555000000070000000000000
009999999999990000011111111110000001ddddd666100001ddddddd6d666100141441661441410019199177199191000005555550000000077777777777000
0002111111112000000024422222000000011ddddd6110000111dd6ddddd61100141444444441410019199999999191000000000000000000007700007700000
00022444422220000000244222220000000011111111000000111666111111000141444444441410019199999999191000000000000000000007700007700000
0002244442222000000004422220000000000111111000000001116111d110000141111111111410019111111111191000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000144444444444410019999999999991000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000111111111111110011111111111111000000000000000000000000000000000
00000000000000000000000000000000000b03000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000b0bbb30b000000000000000000b0b000000000000000000000000000000000000000000000000000000000000000000
000000000000000000bb30000bbb300000bbbbb30b330b000000000000003000000000000bb00000000000000000000000000000000000000000000000000000
00000000000b300003bbb100bbbbb10000bbbbbbbbb330000000000000b0bb000000bb00b000000000000000000000000000000000000000000000b033000000
0000000000bbb3000bbbb100bbbbb13000bbbbbb3b3330000bb0bb00000b00000000030300bb0000000000000000000000000000000000000000000b30000000
0000b00000bb33000bbb3100bbbb3133003bbbb33333300000b330000b33bb00000bb03a0bb000000003300000000000000a9000000000000000003bb3000000
000b330000b3310003b331003bb331330003bb3313330000000300000003300000000a00300bb00000033300000000000009a300000000000000031331300000
000111000001100000331000033310000000333100000000001111000011110000000000b300000000000b000000000000000b00000000000000b131331b0000
0000000000003000000000000000000000000000000000000000000000000000000b300b30a00000003030b0b4000000009040b049000000000031b1bb130000
000000000003b0000000000000000000000000000000000000000000000000000000033b00000000030bbb304b3304b00a0bbb30943304900033313133133300
00000000003b310000000000000000000000a0000000000000000000000000000000b00b000bb00000bbb3b333333b4000bbb3b3133339400003113133113000
003003000013110000000000000000000a9aa9a0000000000bb0000000000000000b0a0333b000000bbbbb33bbb333000bbbbb33bbb1130000bbb111311bbb00
0003300000011000000000000000b00009a24a900000bb00b0000000000000000000000330bb00000b3bbbb13b3333000b3bbbb13b311300000bb31bb13bb000
00bb100000b31300000000000b3bb3b0aa2424a00000030300bb000000000000000000033000000003b3bb311333310003b3bb31133331000000113bb3330000
00013300000110000000000003b2ab300a4242aa000bb0330bb0000000b00b000000000330000000003bb33103331000003bb3310333100000000113b1100000
0031100000311300000bb000bb242ab009a42a9000000000300bb0000bb0b0000000001111000000000333100000000000033310000000000000000000000000
000000000000000000b33b000ba242bb0a9aa9a000000000b3000000000030000000000000000000000000000000000000000000000000000000000000000000
00000000000000000b3423b003ba2b300001a000000b300b3000000000b0b3000000000000000000000000000000000000000000000000000000000000000000
00000000000000000b3243b00b3bb3b000b313300000033b00000000b00b30b0000000000bb00000000000000000000000000000000000000000000000000000
000000000000000000b33b000001b1000bbb13000000b00b000bb0000b3b00000000bb00b00000000000000000000000000003b30b30000000000000b0000000
0000000003000030000bb00000b31bb000033bb0000b000333b00000000b00b00000030300bb0000000000b0330000000000303bb303000000000b3bb3b00000
00b11300033103300bb31bb00bbb3bbb00031bbb0000000330bb000000033b00000bb0382bb000000000000b3000000000000003b0000000000003bddb300000
003b33000b111b300031110000311100003111000000000330000000000330b000008202800bb0000000003bb300000000000cc33cc000000000bb0d90b00000
0001100000b3b30003131330031313300313133000000011110000000011110000002800b382000000000333333000000000c7cccc7c000000000b4009bb0000
0000000000000000000000000000000000000000000000133300000000000000000b300b302800000000b333333b00000000cc7777cc0000000003b49b300000
000000000000000000000000000000000000000000000b3133b30000000000000000033b0000000000303b3333b303000300dccccccd003000000b3bb3b00000
0000000000033000000000000003301331033000000331bbbb133000000000000000b82b000bb000003313bbbb31330000331dddddd1330000000001b1000000
0000000000300300300110030000113333110000000011313311000000000000000b028b33b000000003113333113000000311dddd113000000000b31bb00000
00000000b0b00b0b13133131000bb111111bb000000bb111111bb000000000000000000330bb000000bbb111111bbb0000bbb112211bbb0000000bbb3bbb0000
00bb3000b00bb00bb111111b0000b31bb13b00000000b31bb13b0000000000000000000330000000000bb31bb13bb0000b0bb31bb13bb0b00000003111000000
00b00300033333303b1bb1b30000113bb33300000000113bb33300000000000000000003300000000000113bb33300000000113bb33300000000031313300000
0031130000311300013bb31000000113b110000000000113b110000000000000000000111100000000000113b110000000000113b11000000000000000000000
0000000000000000000000bbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a00000000
00000000000b3300000000b00b0bb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000090aa00000000
0000000000b03300000bb0300330b0000000000000000000000000b000000000000000000000000000000000000000000000000000000000000099aa99900000
000000000b300000000b030bb030b0000000000000000000000000bb000000000000b0000bbb00000000000000000000000000000000000000009adda9000000
0bb030000033b000000b03b00b0030000000000000000000000000b0b0000000000b0bb033b000000000000000000000000000300000000000aa0ddd0aa00000
000b0000000b00000000303003030000000000bbb0000000000000b00b00b0000000000b3000000000000000000000000000000b30000000000a90009aaa0000
0000b0000000b0000000030000300000000000b00b000000000b0030030bb0000000003bb30000000000000000000000000000b000f0f0000000a909a9000000
00031130000311300000311111130000000000b00b0bb000000bb0100030b0000000092332900000000000b003bb000000000b000f0f0f00000999aa99000000
00000000000000000000000300000000000bb0300330b000000b0310b030b0000000a292992a000000000b00333bb00000000300f07070f00000001a190bb000
0000000000000000000000b09a000000000b03000030b000000b030b0b303000000092a2aa29000000000300b3b3b300000bb3000f070f00000bb00110bb3300
000000000000000000000b09a9a00000000b030bbb303000000b030b0b3030000033929299293300000bb300bb300300000033006060606000bbbb3013330030
00000000000000000000030a9a900000000b03b00b003000000300b00b003000000322929922300000003bb00bb0300000000bb00606060000003bb313000000
0000000000000000000bb300a90000000003003003003000000300300300300000bbb222922bbb0000000b000033000000000b00006060000000000310000000
000000000000000000000bb00000000000003030030300000000303003030000000bb32bb23bb000000030b000000000000030b0000000000000003111000000
00000000000000000000000b00000000000003000030000000000300003000000000113bb33300000000000b000000000000000b000000000000031313300000
000000000000000000000311113000000000311111130000000031111113000000000113b1100000000003111130000000000311113000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000bb00b300000
0000000000000000000000000000000000000000000888000000000000000000000000000000000000003330000000000000b0000bbb00000000bbbb03330000
000000000000000000000000000000000000000088800080000000000000000000000000000000000000033000000000000b0bb033b000000000000b30000000
00000000000000000000000000000000000d000080088080000000000000000000000033033000000000000b300000000000000b300000000000088338800000
0000000000000000000000000003000000d0d0000800080000000000000000000000000b30000000000000b000a0a0000000003bb30000000000878888780000
000000000000000000000000003030000b404b000b888b0000000000000000000000003bb300000000b00b000a0a0a0000000a9339a000000000887777880000
0000000000000000000300000bb0bb0000bb300000bb30000000000000000000000003133130000000bb0300a07070a0000079a9aa9700000030288888820300
00000000000000000bb0bb0000bb3000000300000003000000000000000000000000b131331b0000000bb3000a070a000000a979779a00000033122222213300
000000000bb0bb0000bb3000000300000bb300000bb300000000000000000000000031b1bb13000000003300909090900033a9a9aa9a330000b3112222113b00
0000000000bb3000000300000bb30000b0033300b00333000000000000000000003331313313330000000bb009090900000399a9aa99300000bbb11b111bbb00
0bb0bb00000300000bb30000b003330000330030003300300000000000000000000311313311300000000bb00090900000bbb999a99bbb00000bb31bb13bb000
00b3300000b3000000033300003300300003b0000003b000000000000000000000bbb111311bbb00003330b000000000000bb39bb93bb0000000113bb3330000
0003000000033000003300000003b00000330b0000330b000000000000000000000bb31bb13bb0000003300b000000000000113bb33300000000011111100000
00030000000300000003000000330000000300000003000000000000000000000000113bb3330000000003333330000000000113b11000000000000000000000
001111000011110000111100001111000011110000111100000000000000000000000113b1100000000000000000000000000000000000000000000000000000
55550000555500005500000055550000000000000000000000000000000030000000000000000000000000000b03300000000000000000000000000000000000
0550000055050000550000005505000000000000009000090bbb0b3000bb3b300090a00000000bbb0088828000b0077000000000000000000000000000000000
0550000055050000550000005555000000bb03300009b039b003b3000003b3000099aa990000b0b3002000200b00706600000000000000000000000000000000
05500000555500005555000055050000008b3320000b303300943490007c3c6000a24290000b0b03000288000b00600600000000000000000000000000000000
0000000000000000000000000000000008888882090000000a4949490cc766dd0aa424aa0bb0b030000080000300066000000000000000000000000000000000
0000000000000000000000000000000008e8888200930bb30a4a4a490cccccdd009242a00b0b030000bbb3300030000000000000000000000000000000000000
0000000000000000000000000000000008ee882800330bb3094949490cdcdddd099aa9900300b0000003b0000003300000650006666607000000000000000000
0000000000000000000000000000000000882280000003330094949000cdcdd00000a0900333b000000033000000000006570066555760700000000000000000
55550000555500005555000055550000811111110ddd00000dddddd0000000000044440000111100000000000000000005750076111770600000000000000000
5505000055550000550000005550000017777771d776d000dddddddd000000000004200e111bb111000000000000000000056057777750600000000000000000
5555000055050000555000005500000016111710d7dd6d00ddd00ddd0000000000eeeee01bbbbbb1000000000000000000005655555550500000000000000000
550000005505000055000000555500001611710056d7d500dd00dddd400000040041120e01bbbb10000000000000000000000555675655000000000000000000
0000000000000000000000000000000016161610056d70000d0dddd024242424041131201c1bb1c1000000000000000000000055675650000000000000000000
000000000000000000000000000000001661667100550644000dd00022424242041311201c1111c1000000000000000000000005665600000000000000000000
00000000000000000000000000000000161017710000020400000000242424220411112001cccc10000000000000000000000000000000000000000000000000
000000000000000000000000000000001100011100000422000dd000022222200044220000111100000000000000000000000000000000000000000000000000
55550000555000005505000055550000011111000dddd0000000000000bbbb001111111111111111000000000000000000000000000000000000000000000000
5505000050550000550500000550000016777611057650000000000000b11b00188118811bbbbcc1000000000000000000000000000000000000000000000000
5550000055050000555500000550000077777777576dd50044444222bbb11bbb188828811b111cc1000000000000000000000000000000000000000000000000
550500005555000055550000555500006776777655d7bdd041111112b111111b11888211bbb11181000000000000000000000000077700000000000000000000
0000000000000000000000000000000067611766005b7bbd44444222b111111b112888111b111888000000000000000000000000700060000000000000000000
00000000000000000000000000000000761766110053bbbd01111110bbb11bbb1882888114411181000000000000000000000006677005000000000000000000
0000000000000000000000000000000017171100000533350211112000b11b001881188114488881000000000000000000000065567505000000000000000000
0000000000000000000000000000000001110000000555550244422000bbbb001111111111111111000000000000000000000651167550000000000000000000
55550000500500005505000055550000777000007707000077070000000000000000000000dddd00000000000000000000000651675565000000000000000000
5550000055050000550500005500000070770000770700007707000000000000000006600d111dd0000000000000000000000677757556000000000000000000
0555000055550000555500005500000077070000777700007777000000000000d600600dd6666d15000000000000000000000065566750000000000000000000
555500005555000005500000555500007777000077770000077000000000000066ddd00dd1111d15000000000000000000760005556600000000000000000000
00000000000000000000000000000000000000000000000000000000000000000d61160dd1bb1d15000000000000000000675555555000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000d166160d1bb1d15000000000000000000565000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000d111160d1111d15000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000dddd000ddddd50000000000000000000000000000000000000000000000000
__label__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000dddb113ddd00000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d1113b33111d0000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d1100110011d0000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000006100000000160000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000001666666666610000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000080000000000000000000000000000d11111111d00000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000077777700000000000000000000066dddddddddd0000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000060007000000000000000000000d66d6dd6ddd6dd000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000600700000000000000000000001ddddddd6d6661000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000060606000000000000000000000111dd6ddddd611000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000006606670000000000000000000001116661111110000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000060007700000000000000000000001116111d1100000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000024444444420000000000000000000000000000000000000000000
00000000224444b44422000000000000000000000000000000000000000000000000000000200000000002000000000000000000000000000000000000000000
0000000020000b330002000000000000000000000000000000000000000000000000000000404040204004000000000000000000000000000000000000000000
00000000404041114004000000000000000000000000000000000000000000000000000000400204020404000000000000000000000000000000000000000000
00000000400204020404000000000000000000000000000000000000000000000000000000902040404009000000000000000000000000000000000000000000
00000000902040404009000000000000000000000000000000000000000000000000000000099999999990000000000000000000000000000000000000000000
00000000999999999999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000020000000020000000000000000000000000000000000000000000000000000000002442222200000000000000000000000000000000000000000000
00000000022444422220000000000000000000000000000000000000000000000000000000002442222200000000000000000000000000000000000000000000
00000000022444422220000000000000000000000000000000000000000000000000000000000442222000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000dddddd00000000000000000000000000000
000000000000000000000bb0bb000000000000000000000000000000000000000000000000000000000000000000d100001d0000000000000000000000000000
000000000000000000000db33dd00000000000000000000000000000000000000000000000000000000000000000610000160000000000000000000000000000
00000000000000000000d103001d0000000000000000000000000000000000000000000000000000000000000000166666610000000000000000000000000000
00000000000000000000611111160000000000000000000000000000000000000000000000000000000000000000011111100000000000000000000000000000
000000000000000000001666666100000000000000000000002244b11344220000000000000000000000000000000d1111d00000000000000000000000000000
0000000000000000000001111110000000000000000000000020003b33000200000000000000000000000000000066dddddd0000000000000000000000000000
000000000000000000000d1111d0000000000000000000000040404110400400000000000000000000000000000d66dddd6dd000000000000000000000000000
0000000000000000000066dddddd00000dddddbdddd0000000400204020404000000000000000000000000000001ddddd6661000000000000000000000000000
0000000000000000000d66dddd6dd000d1111b33111d0000009020404040090000000000000000000000000000011ddddd611000000000000000000000000000
00000000000000000001ddddd6661000d1100111011d000000999999999999000000000000000000000000000000111111110000000000000000000000000000
000000000000000000011ddddd611000610000000016000000020000000020000000000000000000000000000000011111100000000000000000000000000000
00000000000000000000111111110000166666666661000000022444422220000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000111111000000d11111111d0000000022444422220000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000066dddddddddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000d66d6dd6ddd6dd00000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000001ddddddd6d666100000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000111dd6ddddd61100000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000111666111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000001116111d110000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000244b113442000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000020003b33000200000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000040404110400400000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000040020402040400000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000090204040400900000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000009999999999000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000244222220000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000244222220000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000044222200000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00555555555555500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00050000000000500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00050550550550500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00050000000000500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00050055055005000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00050000000005000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00055555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00055555555555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00005500005500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00005500005500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

__sfx__
00070000040500a05011050260501b0500705014050210502a050270501e050130500605005050150501e050160500c0500a0500e05014050200502705028050210500f0500e050140501b050230502a05027050
00100000000001f6501e6501e6501d6501d6501d6501d6501d6501e6501f650216502265023650000002565026650276502765027650246501f650136501265012650126501565018650166501e6500000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0010000023650236502365025650000002765000000000002a650000002c650000002f6502f6502c65000000276500000000000226501e6501d6501c6501c6501d6501f650216500000026650286502565000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000e1500e1500e15017650221501c1501815020250202501e250141501d2501b2501a2500c1500c1500d1500e15012150171501d1502115025150191500715007150091501c65024650000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000001a6501a6501a6501a6501b6501c6501d6501d650000001a65017650146501365013650000001365000000146500000015650000000000000000156500000000000000001565000000000001565015650

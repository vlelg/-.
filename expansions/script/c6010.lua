--Number c6010: Numerronius the Divine Giant
function c6010.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.XyzFilterFunction(c,12),5)
	c:EnableReviveLimit()
	
	--battle indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(c6010.indes)
	c:RegisterEffect(e1)
	
	--disable C monsters
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(c6010.disable)
	e2:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e2)
	
	--cannot attack
     local e3=e2:Clone()
     e3:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
     c:RegisterEffect(e3)
	
	--destroy and sp summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(6010,2))
	e4:SetCategory(CATEGORY_RELEASE+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetProperty(EFFECT_FLAG_REPEAT)
	e4:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e4:SetCondition(c6010.descon)
	e4:SetTarget(c6010.destg)
	e4:SetOperation(c6010.desop)
	c:RegisterEffect(e4)
	
	--Destroy replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTarget(c6010.desreptg)
	e5:SetOperation(c6010.desrepop)
	c:RegisterEffect(e5)
	
	--destroy monster on the field
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(6010,1))
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetHintTiming(0,0x1e0)
	e6:SetCountLimit(1)
	e6:SetCost(c6010.descost)
	e6:SetTarget(c6010.tg)
	e6:SetOperation(c6010.op)
	c:RegisterEffect(e6)
	
    
end
c6010.xyz_number=1000

function c6010.indes(e,c)
	return not c:IsSetCard(0x48)
end

function c6010.disable(e,c)
	return c:IsSetCard(0x1048) or c:IsSetCard(0x1073)
end

function c6010.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp or Duel.GetTurnPlayer()==1-tp
end
function c6010.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c6010.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,e:GetHandler())
	Duel.Destroy(g,REASON_EFFECT)
	
	--Special Summon
	local c=e:GetHandler()
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(6010,3))
	e1:SetCategory(CATEGORY_RELEASE+CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F) 
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_REPEAT)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e1:SetTarget(c6010.target)
	e1:SetOperation(c6010.activate)
	c:RegisterEffect(e1)
	if not c6010.global_check then
		c6010.global_check=true
		c6010[0]=false
		c6010[1]=false
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetOperation(c6010.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c6010.clear)
		Duel.RegisterEffect(ge2,0)
	end	
end
---Special Summon monsters destroyed this turn
function c6010.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		local pos=tc:GetPosition()
		if  tc:IsLocation(LOCATION_GRAVE) and tc:IsReason(REASON_BATTLE+REASON_EFFECT)
			and tc:GetControler()==tc:GetPreviousControler() then
			c6010[tc:GetControler()]=true
		end
		tc=eg:GetNext()
	end
end
function c6010.clear(e,tp,eg,ep,ev,re,r,rp)
	c6010[0]=false
	c6010[1]=false
end
function c6010.filter(c,id,e,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:GetTurnID()==id and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c6010.condition(e,tp,eg,ep,ev,re,r,rp)
	return c6010[tp] and Duel.GetFlagEffect(tp,c6010)==0
end
function c6010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(c6010.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,Duel.GetTurnCount(),e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	Duel.RegisterFlagEffect(tp,c6010,RESET_PHASE+PHASE_END,0,1)
end
function c6010.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft1==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c6010.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,ft1,ft1,nil,Duel.GetTurnCount(),e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENCE)
		Duel.BreakEffect()
	end
end
----Avoid Destrution
function c6010.repfilter(c)
	return c:IsFaceup() and not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_BATTLE_DESTROYED)
end
function c6010.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsOnField() and c:IsFaceup()
		and Duel.IsExistingMatchingCard(c6010.repfilter,tp,LOCATION_MZONE,0,1,c) end
	if Duel.SelectYesNo(tp,aux.Stringid(6010,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectMatchingCard(tp,c6010.repfilter,tp,LOCATION_MZONE,0,1,1,c)
		e:SetLabelObject(g:GetFirst())
		Duel.HintSelection(g)
		g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	else return false end
end
function c6010.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	tc:SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.Destroy(tc,REASON_EFFECT+REASON_REPLACE)
end

-------Destroy Monster on field
function c6010.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c6010.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c6010.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
	
	function c6010.filter2(c,e,tp)
	return  c:IsType(TYPE_XYZ) and c:IsSetCard(0x1048) or c:IsSetCard(0x1073) or c:IsCode(6006) or c:IsCode(6010)
	and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
		and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
    end

    sg=Duel.GetOperatedGroup()
	local d1=0
	local d2=0
	local tc=sg:GetFirst()
	while tc do
		if tc then
			if tc:GetPreviousControler()==0 then d1=d1+1
			else d2=d2+1 end
		end
		tc=sg:GetNext()
	end
	if d1>0  then 	
    Duel.RegisterFlagEffect(tp,2027,RESET_PHASE+PHASE_END,0,1)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingTarget(c6010.filter2,tp,LOCATION_EXTRA,LOCATION_EXTRA,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,true,true,nil,1,tp,0x13)
	local g=Duel.SelectTarget(tp,c6010.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)	
	 Duel.RegisterFlagEffect(tp,2027,RESET_PHASE+PHASE_END,0,1)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
	end	
	end
	
	if d2>0  then 	
	Duel.RegisterFlagEffect(1-tp,2010,RESET_PHASE+PHASE_END,0,1)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>-1
		and Duel.IsExistingTarget(c6010.filter2,1-tp,LOCATION_EXTRA,0,1,nil,e,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,true,true,nil,1,1-tp,0x13)
	local g=Duel.SelectTarget(tp,c6010.filter2,1-tp,LOCATION_EXTRA,0,1,1,nil,e,1-tp)	
	 Duel.RegisterFlagEffect(1-tp,2010,RESET_PHASE+PHASE_END,0,1)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)	
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,1-tp,true,true,POS_FACEUP)
	end   
	end
end




















--Numeron Network
function c6005.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	
	--Active without remove Xyz material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c6005.rcon)
	e2:SetOperation(c6005.rop)
	c:RegisterEffect(e2)
	
	 --Auto-activate from Hand
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1)
	e3:SetCost(c6005.cost2)
    e3:SetTarget(c6005.fromhandcon)
    e3:SetOperation(c6005.fromhandop)
    c:RegisterEffect(e3)
	
	--1) Numeron Direct
	local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(6005,0))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTarget(c6005.tg)
	e4:SetCost(c6005.cost1)
	e4:SetCondition(c6005.condition)
	e4:SetOperation(c6005.op)
	e4:SetCountLimit(1)
	c:RegisterEffect(e4)
	
	--2) Numeron Chaos Ritual
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(6005,1))
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCost(c6005.cost1)
	e5:SetCondition(c6005.con)
	e5:SetTarget(c6005.target)
	e5:SetOperation(c6005.activate)
	c:RegisterEffect(e1)
	if not c6005.global_check then
		c6005.global_check=true
		c6005[0]=false
		c6005[1]=false
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetOperation(c6005.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c6005.clear)
		Duel.RegisterEffect(ge2,0)
	end
	e5:SetCountLimit(1)
	c:RegisterEffect(e5)
	
	--3) Numeron Rewriting Magic
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(6005,2))
	e6:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_CHAINING)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCountLimit(1)
	e6:SetCost(c6005.cost1)
	e6:SetCondition(c6005.condition2)
	e6:SetTarget(c6005.target2)
	e6:SetOperation(c6005.activate2)
	c:RegisterEffect(e6)
	
	--4) Numeron Rewriting Xyz
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(6005,3))
	e7:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_SPSUMMON)
	e7:SetRange(LOCATION_SZONE)
	e7:SetCondition(c6005.condition3)
	e7:SetCost(c6005.cost1)
	e7:SetCountLimit(1)
	e7:SetTarget(c6005.target3)
	e7:SetOperation(c6005.activate3)
	c:RegisterEffect(e7)
	
	--5) Numeron Storm
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(6005,4))
	e8:SetType(EFFECT_TYPE_QUICK_O)
	e8:SetCode(EVENT_FREE_CHAIN)
	e8:SetRange(LOCATION_SZONE)
	e8:SetCondition(c6005.condition4)
	e8:SetTarget(c6005.target4)
	e8:SetCost(c6005.cost1)
	e8:SetOperation(c6005.activate4)
	e8:SetCountLimit(1)
	c:RegisterEffect(e8)
end
--------------------------Activate from hand:
function c6005.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,6005)==0 end
	Duel.RegisterFlagEffect(tp,6005,RESET_PHASE+PHASE_DRAW,0,1)
end

function c6005.fromhandcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()~=e:GetHandlerPlayer()
	and not Duel.IsExistingMatchingCard(c6005.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
	and  Duel.GetCurrentPhase()==PHASE_DRAW
end
function c6005.fromhandop(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetHandler()
    if tc then
        if Duel.GetFieldCard(tp,LOCATION_SZONE,5)~=nil then
            Duel.Destroy(Duel.GetFieldCard(tp,LOCATION_SZONE,5),REASON_RULE)
            Duel.BreakEffect()
            Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
        elseif Duel.GetFieldCard(1-tp,LOCATION_SZONE,5)~=nil
            and Duel.GetFieldCard(1-tp,LOCATION_SZONE,5):IsFaceup() then
                Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
                Duel.Destroy(Duel.GetFieldCard(1-tp,LOCATION_SZONE,5),REASON_RULE)
        else
            Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
        end
        local te=tc:GetActivateEffect()
        local tep=tc:GetControler()
        local cost=te:GetCost()
        if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
        Duel.RaiseEvent(tc,EVENT_CHAIN_SOLVED,tc:GetActivateEffect(),0,tp,tp,Duel.GetCurrentChain())
    end
end
---------------------------
function c6005.cfilter(c)
	return not c:IsStatus(STATUS_LEAVE_CONFIRMED)
end

function c6005.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,6005)==0 end
	Duel.RegisterFlagEffect(tp,6005,RESET_PHASE+PHASE_END,0,1)
end


function c6005.condition(e,tp,eg,ep,ev,re,r,rp) --Numeron Direct
	return not Duel.IsExistingMatchingCard(c6005.cfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) 
    and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,6007)
end


function c6005.rcon(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	return e:GetHandler():GetFlagEffect(6005+ep)==0 
	    and not re:GetHandler():IsCode(6010) 
		and not re:GetHandler():IsCode(6011) 
		and bit.band(r,REASON_COST)~=0 and re:GetHandler():IsType(TYPE_XYZ) and re:GetHandler():IsSetCard(667) 		
		and re:GetHandler():GetOverlayCount()>=ev-1
end
function c6005.rop(e,tp,eg,ep,ev,re,r,rp)
local tc=e:GetHandler()
    if e:GetLabel()~=0 then
        Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
        local te=tc:GetActivateEffect()
        local tep=tc:GetControler()
        local cost=te:GetCost()
        if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
	local ct=bit.band(ev,0xffff)
	end
		
end

-----------Numeron Direct From Deck
function c6005.filter(c,e,tp)
	return c:IsAttackBelow(1000) and c:IsSetCard(667) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end

function c6005.tgfilter(c)
	return c:IsCode(6007) and c:IsAbleToGrave()
end


function c6005.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_EXTRA) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>=4
		and Duel.IsExistingTarget(c6005.filter,tp,LOCATION_EXTRA,0,4,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c6005.filter,tp,LOCATION_EXTRA,0,4,4,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
	if chk==0 then return Duel.IsExistingMatchingCard(c6005.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end

function c6005.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<sg:GetCount() then return end
	if sg:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			tc:RegisterFlagEffect(6005,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
			tc=g:GetNext()
		end 
		Duel.SpecialSummonComplete()
		sg:KeepAlive()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabelObject(sg) 
		e1:SetOperation(c6005.rmop)
		Duel.RegisterEffect(e1,tp)
	end	
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c6005.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
	
end

function c6005.rmfilter(c)
	return c:GetFlagEffect(6005)>0
end

function c6005.rmop(e,tp,eg,ep,ev,re,r,rp)
	local sg=e:GetLabelObject()
	local tg=sg:Filter(c6005.rmfilter,nil)
	sg:DeleteGroup()
	Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
end
-------------Numeron Chaos Ritual from deck

function c6005.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		local pos=tc:GetPosition()
		if  tc:IsCode(6006) and tc:IsLocation(LOCATION_GRAVE) and tc:IsReason(REASON_BATTLE+REASON_EFFECT)
			and tc:GetControler()==tc:GetPreviousControler() then
			c6005[tc:GetControler()]=true
		end
		tc=eg:GetNext()
	end
end
function c6005.clear(e,tp,eg,ep,ev,re,r,rp)
	c6005[0]=false
	c6005[1]=false
end
function c6005.sppfilter(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:GetRank()==12 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c6005.spfilter(c,cat)
	return  c:IsType(TYPE_XYZ) and (c:IsSetCard(0x1048) or c:IsSetCard(0x1073) or c:IsSetCard(667))
end
function c6005.filter2(c,cat)
	return c:IsType(TYPE_SPELL) and c:IsCode(6005)
end
function c6005.con(e,tp,eg,ep,ev,re,r,rp)
	return c6005[tp] and Duel.GetFlagEffect(tp,6005)==0 and 
	not Duel.IsExistingMatchingCard(c6005.cfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) 
    and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,6009)
end

function c6005.tggfilter(c)
	return c:IsCode(6009) and c:IsAbleToGrave()
end


function c6005.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c6005.spfilter,tp,LOCATION_GRAVE,0,4,nil,0x1073)
		and Duel.IsExistingTarget(c6005.filter2,tp,LOCATION_GRAVE,0,1,nil,6005) 
		and Duel.IsExistingMatchingCard(c6005.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g1=Duel.SelectTarget(tp,c6005.spfilter,tp,LOCATION_GRAVE,0,4,4,nil,0x1073)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g2=Duel.SelectTarget(tp,c6005.filter2,tp,LOCATION_GRAVE,0,1,1,nil,6005)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g1,5,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c6005.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.GetMatchingGroup(c6005.sppfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	if g:GetCount()==0 then return end
	local mg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if mg:GetCount()~=5 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,1,1,nil)
	local sc=sg:GetFirst()
	if sc then
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		Duel.Overlay(sc,mg)
	end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c6005.tggfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
-----------Numeron Rewriting Magic from deck

function c6005.ccfilter(c)
	return not c:IsStatus(STATUS_LEAVE_CONFIRMED)
end

function c6005.tgg2filter(c)
	return c:IsCode(6012) and c:IsAbleToGrave()
end


function c6005.condition2(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst():IsType(TYPE_SPELL) and rp~=tp and Duel.IsChainNegatable(ev)
	and not Duel.IsExistingMatchingCard(c6005.cfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) 
    and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,6012)
end
function c6005.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(1-tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
	end
end
function c6005.activate2(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
	
	local g1=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
	Duel.ConfirmCards(tp,g1)
	
	function c6005.negfilter(c)
	return c:IsType(TYPE_SPELL) and not c:IsType(TYPE_TRAP) and c:IsSSetable()
    end
	   
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c6005.negfilter,1-tp,LOCATION_DECK,0,1,nil)
    end	
  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ACTIVATE)
	local g=Duel.SelectMatchingCard(tp,c6005.negfilter,1-tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(1-tp,g:GetFirst())
		Duel.ConfirmCards(tp,g)
	end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c6005.tgg2filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
	
end
--------------------Numeron Rewriting Xyz from deck

function c6005.cfilter3(c)
	return not c:IsStatus(STATUS_LEAVE_CONFIRMED)
end

function c6005.tgg3filter(c)
	return c:IsCode(6013) and c:IsAbleToGrave()
end

function c6005.condition3(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and eg:GetFirst():IsType(TYPE_XYZ) and Duel.GetCurrentChain()==0 
	and not Duel.IsExistingMatchingCard(c6005.cfilter3,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) 
	and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,6013)
end

function c6005.filtersp(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c6005.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
end
function c6005.activate3(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.NegateSummon(eg:GetFirst())
	Duel.Destroy(eg,REASON_EFFECT)
	
	local g1=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
	Duel.ConfirmCards(tp,g1)
	
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c6005.filtersp,tp,LOCATION_DECK,0,1,nil,e,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,1-tp,LOCATION_DECK)
	
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c6005.filtersp,1-tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
	    if tc and Duel.SpecialSummonStep(tc,0,tp,1-tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2,true)
		Duel.SpecialSummon(g,0,tp,1-tp,false,false,POS_FACEUP)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c6005.tgg3filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
	end
end
-------------------Numeron Storm from deck
function c6005.cfilter4(c)
	return not c:IsStatus(STATUS_LEAVE_CONFIRMED)
end

function c6005.condition4(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c6005.cfilter4,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) 
	and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,6014)
end

function c6005.tgg4filter(c)
	return c:IsCode(6014) and c:IsAbleToGrave()
end

function c6005.filterdg(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c6005.target4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c6005.filterdg,tp,0,LOCATION_ONFIELD,1,nil) end
	local sg=Duel.GetMatchingGroup(c6005.filterdg,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c6005.activate4(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c6005.filterdg,tp,0,LOCATION_ONFIELD,e:GetHandler())
	Duel.Destroy(sg,REASON_EFFECT)
	Duel.Damage(1-tp,1000,REASON_EFFECT)
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c6005.tgg4filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end

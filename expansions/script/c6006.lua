--Number C1: Gate of Chaos Numeron - Shunya
function c6006.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.XyzFilterFunction(c,2),4,c6006.ovfilter)
	c:EnableReviveLimit()
	
	--Remove Monsters
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c6006.eqcon)
	e1:SetTarget(c6006.destg)
	e1:SetOperation(c6006.desop)
	c:RegisterEffect(e1)
	
	--battle indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(c6006.indes)
	c:RegisterEffect(e2)
		
	--self destroy
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_SELF_DESTROY)
	e3:SetCondition(c6006.descon)
	c:RegisterEffect(e3)
end

c6006.xyz_number=1

function c6006.filter(c)
	return c:IsFaceup() and c:IsCode(6005)
end

function c6006.ovfilter(c)
	return c:IsFaceup() and c:IsCode(6001) and Duel.IsExistingMatchingCard(c6006.filter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end

function c6006.indes(e,c)
	return not c:IsSetCard(0x48)
end

function c6006.descon(e)
	local ev,ep=Duel.GetEnvironment()
	return Duel.GetEnvironment()~=6005
end
-------------------------------Remove Monsters

function c6006.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end

function c6006.cfilter(c)
	return c:IsAbleToRemove()
end
function c6006.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c6006.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c6006.cfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c6006.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c6006.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT,LOCATION_REMOVED)
		local dg=Duel.GetOperatedGroup()
	local tc=dg:GetFirst()
	local dam=0
	while tc do
		local atk=tc:GetTextAttack()
		if atk<0 then atk=0 end
		dam=dam+atk
		tc=dg:GetNext()
		
		damtotal=dam
	end
	local damtotal
	end
	
	--sp summon
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,1)
	e1:SetCondition(c6006.spcon)
	e1:SetTarget(c6006.sptg)
	e1:SetOperation(c6006.spop)
	e1:SetLabel(0)
	c:RegisterEffect(e1)
	
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCost(c6006.damcost)
	e3:SetOperation(c6006.damop)
	c:RegisterEffect(e3)
	
end

function c6006.spcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp then return end
	local ct=e:GetLabel()
	e:SetLabel(ct+1)
	return ct==0
end


function c6006.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	
end
function c6006.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end	
end

function c6006.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end

function c6006.damop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.Damage(1-tp,damtotal,REASON_EFFECT)
	end	
end

--Agregarle Costo para causar daño
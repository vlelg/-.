--Number 2: Gate of Numeron - Dve
function c6002.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.XyzFilterFunction(c,1),3)
	c:EnableReviveLimit()
	
	--battle indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(c6002.indes)
	c:RegisterEffect(e1)
	
	--Numeron atk up
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_BATTLED)
	e2:SetCondition(c6002.descon)
	e2:SetCost(c6002.damcost)
	e2:SetOperation(c6002.desop)
	c:RegisterEffect(e2)
	
end
c6002.xyz_number=2

function c6002.indes(e,c)
	return not c:IsSetCard(0x48)
end

function c6002.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttackTarget()~=nil
end

function c6002.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end

function c6002.filter(c)
	return c:IsFaceup() and c:IsSetCard(667) 
end

function c6002.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c6002.filter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(tc:GetAttack())
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end

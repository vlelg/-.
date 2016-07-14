--Number 3: Gate of Numeron - Trini
function c6003.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.XyzFilterFunction(c,1),3)
	c:EnableReviveLimit()
	
	--battle indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(c6003.indes)
	c:RegisterEffect(e1)
	
	--Numeron atk up
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_BATTLED)
	e2:SetCondition(c6003.descon)
	e2:SetCost(c6003.damcost)
	e2:SetOperation(c6003.desop)
	c:RegisterEffect(e2)
	
end
c6003.xyz_number=3

function c6003.indes(e,c)
	return not c:IsSetCard(0x48)
end

function c6003.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttackTarget()~=nil
end

function c6003.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end

function c6003.filter(c)
	return c:IsFaceup() and c:IsSetCard(667)
end

function c6003.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c6003.filter,tp,LOCATION_MZONE,0,nil)
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

--MMJ: Baku-sui sei

function c8103.initial_effect(c)
	
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,c8103.filter,aux.NonTuner(Card.IsSetCard,0x2135),2)
	
	--only synchro summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.synlimit)
	c:RegisterEffect(e1)
	
	--cannot be targetted
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c8103.cnvl)
	c:RegisterEffect(e2)
	--cannot be destroyed
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(c8103.cdvl)
	c:RegisterEffect(e3)
	
	--ATK / DEF update
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c8103.adcn)
	e4:SetValue(c8103.advl)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_UPDATE_DEFENCE)
	c:RegisterEffect(e5)
	
	--negate
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(8103,0))
	e6:SetCategory(CATEGORY_DISABLE+CATEGORY_DAMAGE)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_CHAINING)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(2)
	e6:SetCondition(c8103.ngcn)
	e6:SetCost(c8103.ngco)
	e6:SetTarget(c8103.ngtg)
	e6:SetOperation(c8103.ngop)
	c:RegisterEffect(e6)
	
end

function c8103.filter(c)
	return c:IsSetCard(0x2135)
end

--cannot be tg / ds
function c8103.cnvl(e,re,rp)
	return rp~=e:GetHandlerPlayer() and not re:GetHandler():IsImmuneToEffect(e)
end

function c8103.cdvl(e,re,tp)
	return e:GetHandler():GetControler()~=tp
end

--ATK / DEF update
function c8103.adcn(e)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL)
		and (Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler())
		and Duel.GetAttackTarget()~=nil
end

function c8103.advl(e,c)
		if e:GetHandler():GetBattleTarget():IsType(TYPE_XYZ) then
		return e:GetHandler():GetBattleTarget():GetRank()*100
	else
		return e:GetHandler():GetBattleTarget():GetLevel()*100
	end
end

--negate
function c8103.ngcn(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler()~=e:GetHandler() and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and Duel.IsChainNegatable(ev)
end

function c8103.ngcofilter(c)
	return c:IsSetCard(0x2135) and ( c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL) ) 
		and c:IsAbleToRemoveAsCost()
end
function c8103.ngco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c8103.ngcofilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c8103.ngcofilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end

function c8103.ngtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end

function c8103.ngop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) then
		Duel.Damage(1-tp,1000,REASON_EFFECT)
		Duel.SelectYesNo(tp,aux.Stringid(8103,1))
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,1,nil)
			if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
	end
end

	
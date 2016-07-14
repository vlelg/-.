--soboku: 영목

function c8084.initial_effect(c)

	--only 1
	c:SetUniqueOnField(1,0,8084)
	
	--returnto deck + draw
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c8084.rdtg)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(8084,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c8084.drco)
	e2:SetTarget(c8084.drtg)
	e2:SetOperation(c8084.drop)
	c:RegisterEffect(e2)
	
	--migawari
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(c8084.mrtg)
	e3:SetValue(c8084.mrvl)
	e3:SetOperation(c8084.mrop)
	c:RegisterEffect(e3)

end

--returnto deck
function c8084.rdtgfilter(c)
	return c:IsSetCard(0x2136) and c:IsAbleToDeck()
end
function c8084.rdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return true end
	if c8084.drtg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
		and Duel.SelectYesNo(tp,94) then
		e:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e:SetOperation(c8084.drop)
		c8084.drtg(e,tp,eg,ep,ev,re,r,rp,1,chkc)
		e:GetHandler():RegisterFlagEffect(0,RESET_CHAIN,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(8084,1))
	else
		e:SetCategory(0)
		e:SetProperty(0)
		e:SetOperation(nil)
	end
end

function c8084.drcofilter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToRemoveAsCost()
		and not (c:IsType(TYPE_QUICKPLAY) or c:IsType(TYPE_CONTINUOUS) or c:IsType(TYPE_EQUIP) or c:IsType(TYPE_FIELD) or c:IsType(TYPE_RITUAL))
end
function c8084.drco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c8084.rdcofilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c8084.rdcofilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end

function c8084.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp)
		and c8084.rdtgfilter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and e:GetHandler():GetFlagEffect(8084)==0
		and Duel.IsExistingTarget(c8084.rdtgfilter,tp,LOCATION_GRAVE,0,3,nil) end
	e:GetHandler():RegisterFlagEffect(8084,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c8084.rdtgfilter,tp,LOCATION_GRAVE,0,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,3,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end

function c8084.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=3 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	Duel.ShuffleDeck(tp)
	local g=Duel.GetOperatedGroup()
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct==3 then
		Duel.BreakEffect()
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end

--migawari
function c8084.mrtgfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
		and c:IsSetCard(0x2136)
end
function c8084.mrtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c8084.mrtgfilter,1,nil,tp) end
	return Duel.SelectYesNo(tp,aux.Stringid(8084,2))
end

function c8084.mrvl(e,c)
	return c8084.mrtgfilter(c,e:GetHandlerPlayer())
end
function c8084.mrop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end

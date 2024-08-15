//+------------------------------------------------------------------+
//|                                                 morningstart.mq5 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
#include </TimeserieOperation/TimeserieOperations.mqh>
#include </BaTrade.mqh>
#define  _SYMBOL_ = "EURUSD";
#define  _TIMEFRAME_ = PERIOD_H1;
MqlTradeRequest request;
MqlTradeResult result;
double start_top__ = 0,start_bottom__ = 0,start_body__=0, body__=0, body_top__=0,body_bottom__=0;
double morining_volume = 0;
uint morining_magic_ = -1;

int OnInit()
  {
//---
   start_top__ = 1/2;
   start_bottom__ = 1/2;
   start_body__= 1.0004;
   body__=1.0005;
   body_top__= 3;
   body_bottom__=3;
   morining_volume = 0.5;
   morining_magic_ = 1;
   request.deviation = 5;
   request.symbol = "EURUSD";
   request.volume = morining_volume;
   request.type_filling = ORDER_FILLING_IOC;
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   MqlRates rates[];
   int copy = CopyRates(_SYMBOL_, _TIMEFRAME_,1,15,rates);
   int handelma = iMA(_Symbol,PERIOD_CURRENT, 75, 0,MODE_EMA, PRICE_CLOSE);
   int handelma_ = iMA(_Symbol,PERIOD_CURRENT, 10, 0,MODE_EMA, PRICE_CLOSE);
   ArraySetAsSeries(rates, true);
   if(copy > 0 && checkOpenByMagic(morining_magic_) == false)
     {
      bool moring =  morningStart(rates, start_top__,start_bottom__, start_body__,body__,body_top__, body_bottom__);
      if(moring && argmin(rates) <=2)
        {
         double ask= SymbolInfoDouble(_SYMBOL_, SYMBOL_ASK);
         request.price = ask;
         request.tp = ask + 500*_Point;
         request.sl = ask - 200*_Point;
         request.action = TRADE_ACTION_DEAL;
         request.order = ORDER_TYPE_BUY;
         request.magic = morining_magic_;
         int send = OrderSend(request, result);
        }
     }
  }
//+------------------------------------------------------------------+

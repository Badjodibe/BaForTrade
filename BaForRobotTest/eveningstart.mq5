//+------------------------------------------------------------------+
//|                                                 eveningstart.mq5 |
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
MqlTradeRequest request;
MqlTradeResult result ;
double start_top__ = 0,start_bottom__ = 0,start_body__=0, body__=0, body_top__=0,body_bottom__=0;
double volume = 0;
uint magic_ = -1;

int OnInit()
  {
//--
   start_top__ = 1/2;
   start_bottom__ = 1/2;
   start_body__= 1.0003;
   body__=1.0008;
   body_top__= 3;
   body_bottom__=3;
   volume = 0.5;
   magic_ = 2;
   request.deviation = 5;
   request.magic = magic_;
   request.volume = volume;
   request.symbol = _Symbol;
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
   int copy = CopyRates(_Symbol, PERIOD_H1,1,15,rates);
   ArraySetAsSeries(rates, true);
   int handelma = iMA(_Symbol,PERIOD_CURRENT, 75, 0,MODE_EMA, PRICE_CLOSE);
   int handelma_ = iMA(_Symbol,PERIOD_CURRENT, 10, 0,MODE_EMA, PRICE_CLOSE);
   double maMax[], maMin[];
   bool mamax = nMA(0, 75, 3, maMax);
   bool mamin = nMA(0, 10, 3, maMin);
   if(copy > 0 && checkOpenByMagic(magic_) == false )
     {
      bool evening =  eveningStart(rates, start_top__,start_bottom__, start_body__,body__,body_top__, body_bottom__);
      if(evening){
         if(maMax[1] > maMin[1])
           {
            double bid= SymbolInfoDouble(_Symbol,SYMBOL_BID);
            request.price = bid;
            request.tp = bid - 400*_Point;
            request.sl = bid + 200*_Point;
            request.action = TRADE_ACTION_DEAL;
            request.order = ORDER_TYPE_SELL;
            request.magic = magic_;
            request.type = ORDER_TYPE_SELL;
            int send = OrderSend(request, result);
           }
         else
           {
            if(checkOrderByMagic(magic_) == false)
              {
               double ask= SymbolInfoDouble(_Symbol,SYMBOL_ASK) + 100*_Point;
               request.price = ask ;
               request.tp = ask + 400*_Point;
               request.sl = ask - 200*_Point;
               request.action = TRADE_ACTION_PENDING;
               request.order = ORDER_TYPE_BUY_STOP;
               request.type = ORDER_TYPE_BUY_STOP;
               request.magic = magic_;
               request.expiration = TimeCurrent() + 3600*10;
               request.type_time = ORDER_TIME_SPECIFIED;
               int send = OrderSend(request,result);
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+

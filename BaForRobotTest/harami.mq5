//+------------------------------------------------------------------+
//|                                                       harami.mq5 |
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
MqlTradeRequest harami_request;
MqlTradeResult harami_result;
double harami_start_top = 0, harami_start_bottom = 1/2, harami_start_body = 0;
double harami_body = 0, harami_top = 0, harami_bottom = 0;
double harami_volume = 0;
uint harami_magic_ = -1;
int OnInit()
  {
//---
   harami_start_top = 1/2;harami_start_bottom =1/2; harami_start_body = 1.0005;
   harami_body = 1.001; harami_top = 3; harami_bottom = 3;
   harami_volume = 0.5;
   harami_magic_ = 2;
   harami_request.action = TRADE_ACTION_DEAL;
   harami_request.deviation = 5;
   harami_request.symbol = _Symbol;
   harami_request.magic = harami_magic_;
   harami_request.volume = harami_volume;
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
   int copy = CopyRates(_Symbol, PERIOD_H1,1,20,rates);
   ArraySetAsSeries(rates, true);
   if(copy > 0 && checkOpenByMagic(harami_magic_) == false)
     {
      int harami =  haramiUD(rates,harami_body, harami_top, harami_bottom,harami_start_body, harami_start_top, harami_start_bottom);
      if(harami == 1 && argmin(rates) <=1)
        {
         double ask= SymbolInfoDouble(_Symbol, SYMBOL_ASK);
         harami_request.price = ask;
         harami_request.tp =ask + 450*_Point;
         harami_request.sl = ask - 200*_Point;
         harami_request.order = ORDER_TYPE_BUY;
         int send = OrderSend(harami_request, harami_result);
        }
        else
          {
           if(harami == -1 && argmin(rates) <=1)
           {
            double bid= SymbolInfoDouble(_Symbol, SYMBOL_BID);
            harami_request.price = bid;
            harami_request.tp =bid - 450*_Point;
            harami_request.sl = bid + 200*_Point;
            harami_request.order = ORDER_TYPE_SELL;
            int send = OrderSend(harami_request, harami_result);
           }
          }
     }
  }
//+------------------------------------------------------------------+

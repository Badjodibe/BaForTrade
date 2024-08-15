//+------------------------------------------------------------------+
//|                                               darkcloudcover.mq5 |
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
#include </BaTrade/BaTrade.mqh>
#include </candlepatterns.mqh>
string  SYMBOL_ = "EURUSD";
ENUM_TIMEFRAMES  TIMEFRAME_ = PERIOD_H1;
MqlTradeRequest request;
MqlTradeResult result_;
double cloud_body = 0, cloud_body_top = 0, cloud_body_bottom = 0;
double cloud_volume = 0;
uint cloud_magic_ = -1;
int OnInit()
  {
//---
   cloud_body = 1.0007; cloud_body_top = 4; cloud_body_bottom = 1/2;
   cloud_magic_ = 5;
   cloud_volume = 3;
   request.magic = cloud_magic_;
   request.volume = cloud_volume;
   request.deviation = 5;
   request.symbol = SYMBOL_;
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
   double max_cloud = 0;
   uint argmax_cloud = 0;
   double price = 0;
   MqlRates rates[];
   int copy = CopyRates(SYMBOL_,  TIMEFRAME_,1,3,rates);
   ArraySetAsSeries(rates, true);
   int handelma = iMA(SYMBOL_, TIMEFRAME_, 75, 0,MODE_EMA, PRICE_CLOSE);
   int handelma_ = iMA(SYMBOL_, TIMEFRAME_, 10, 0,MODE_EMA, PRICE_CLOSE);
   int rsi = iRSI(SYMBOL_, TIMEFRAME_,24, PRICE_CLOSE);
   double maMax[], maMin[], force[];
   bool f= nRSI(0, 24, 3, force);
   bool mamax = nMA(0, 75, 3, maMax);
   bool mamin = nMA(0, 10, 3, maMin);
   if(copy > 0 && checkOpenByMagic(cloud_magic_) == false && checkOrderByMagic(cloud_magic_) == false)
      {
      bool cloud = dark(rates, 1.0007);
      bool c1 = force[1] < 45 && force[1] > 30;
      if(cloud)
        {
         if(maMax[1]<maMin[1])
           {
           /*
            bool ok = avgLow(10, _Symbol,PERIOD_CURRENT, price);
            request.action = TRADE_ACTION_PENDING;
            request.type_filling = ORDER_FILLING_IOC;
            request.price = price;
            request.tp = price + 600*_Point;
            request.sl = price - 200*_Point;
            request.expiration = TimeCurrent() + 3600*10;
            request.type_time = ORDER_TIME_SPECIFIED;
            
            if(price > SymbolInfoDouble(_Symbol,SYMBOL_ASK))
              {
               request.type = ORDER_TYPE_BUY_STOP;
              }
             else
               {
                request.type = ORDER_TYPE_BUY_LIMIT;
               }
            int send = OrderSend(request, result_);
            Print(DoubleToString(force[1]));
            */
           }
           
           // Si c'est down'
         else
           {
            if(c1)
              {
               bool ok = avgHigh(10, _Symbol,PERIOD_CURRENT, price);
               request.action = TRADE_ACTION_PENDING;
               request.type_filling = ORDER_FILLING_IOC;
               request.price = price;
               request.tp = price - 600*_Point;
               request.sl = price + 200*_Point;
               request.expiration = TimeCurrent() + 3600*10;
               request.type = ORDER_TYPE_SELL_STOP_LIMIT;
               request.type_time = ORDER_TIME_SPECIFIED;
               if(price > SymbolInfoDouble(_Symbol,SYMBOL_BID))
                 {
                  request.type = ORDER_TYPE_SELL_LIMIT;
                 }
                else
                  {
                   request.type = ORDER_TYPE_SELL_STOP;
                  }
               int send = OrderSend(request, result_);
               Print(DoubleToString(force[1]));
              }
            
           }
     }
   }
 }
//+------------------------------------------------------------------+

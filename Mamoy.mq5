//+------------------------------------------------------------------+
//|                                                        Mamoy.mq5 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
#include <Babrary/baserie/baserie.mqh>
#include <Babrary/candelpatterns.mqh>
#include  </Babrary/batrade.mqh>
int handlemamin = NULL;
int handlemamax = NULL;
int handlersi = NULL;
int minmaperiod = 15;
int maxmaperiod = 75;

double mamax_[], mamin_[], rsi[];
datetime date;
MqlRates candels[];
int OnInit()
  {
//--- create timer
   EventSetTimer(60);
   handlemamin=iMA(_Symbol,PERIOD_H1,minmaperiod,0,MODE_SMA, PRICE_CLOSE);
   handlemamax=iMA(_Symbol,PERIOD_H1,maxmaperiod,0,MODE_SMA, PRICE_CLOSE);
   handlersi = iRSI(_Symbol,PERIOD_H1, 50, PRICE_CLOSE);
   printf(DoubleToString(Point()));
   if(handlersi==INVALID_HANDLE&&handlemamax==INVALID_HANDLE&&handlemamin==INVALID_HANDLE)
     {
      return(INIT_FAILED);
     }
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- destroy timer
   IndicatorRelease(handlersi);
   IndicatorRelease(handlemamax);
   IndicatorRelease(handlemamin);
   EventKillTimer();
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   MqlTradeRequest request;
   MqlTradeResult result;
   double price = 0;
   int copy = CopyRates(_Symbol,PERIOD_H1, 1,10, candels);
   ArraySetAsSeries(candels, true);
   int indice[50];
   int ind = 0;
   if(CopyBuffer(handlemamin, 0, 1, 50, mamin_)
      &&CopyBuffer(handlemamax, 0, 1, 50, mamax_)
      &&CopyBuffer(handlersi, 0, 1, 50, rsi)
      &&copy)
     {
      int buy = crossUp(mamin_, mamax_,30,indice);
      ArraySetAsSeries(mamax_,true);
      ArraySetAsSeries(mamin_, true);
      ArraySetAsSeries(rsi, true);
      double mean = 0;
      
      avgBody(15, _Symbol,PERIOD_H1,mean,1);
      bool condition = body(candels[0]) > 5*mean && upOrdownCandlestick(candels[0]);
      if(buy>0&&condition)
        {
         request.action = TRADE_ACTION_DEAL;
         request.deviation = 5;
         request.symbol = _Symbol;
         request.volume = 0.3;
         request.type_filling = ORDER_FILLING_IOC;
         request.type = ORDER_TYPE_SELL;
         price = SymbolInfoDouble(_Symbol,SYMBOL_BID);
         request.price = price;
         request.sl = price + _Point*300;
         request.tp = price - _Point*1000;
         request.magic = 1;
         bool send = OrderSend(request, result);
         date  = TimeCurrent() - 200;
        }
      
     }
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Trade function                                                   |
//+------------------------------------------------------------------+
void OnTrade()
  {
//---
   
  }
//+------------------------------------------------------------------+
//| TradeTransaction function                                        |
//+------------------------------------------------------------------+
void OnTradeTransaction(const MqlTradeTransaction& trans,
                        const MqlTradeRequest& request,
                        const MqlTradeResult& result)
  {
//---
   double price = 0;
   if(checkdealByMagic(1,date, price))
     {
      printf("Ok");
     }
  }
//+------------------------------------------------------------------+
//| Tester function                                                  |
//+------------------------------------------------------------------+
double OnTester()
  {
//---
   double ret=0.0;
//---

//---
   return(ret);
  }
//+------------------------------------------------------------------+
//| TesterInit function                                              |
//+------------------------------------------------------------------+
void OnTesterInit()
  {
//---
   
  }
//+------------------------------------------------------------------+
//| TesterPass function                                              |
//+------------------------------------------------------------------+
void OnTesterPass()
  {
//---
   
  }
//+------------------------------------------------------------------+
//| TesterDeinit function                                            |
//+------------------------------------------------------------------+
void OnTesterDeinit()
  {
//---
   
  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| BookEvent function                                               |
//+------------------------------------------------------------------+
void OnBookEvent(const string &symbol)
  {
//---
   
  }
//+------------------------------------------------------------------+


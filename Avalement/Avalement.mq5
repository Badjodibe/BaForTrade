//+------------------------------------------------------------------+
//|                                                    Avalement.mq5 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
#include  <Babrary/baserie/baserie.mqh>
#include  <Babrary/batrade.mqh>
#include  <Babrary/avalement.mqh>

int bahighlowhandel;
int magich4buy, magich4sell, magicd1buy, magicd1sell, magicwsell, magicwbuy, magicmnsell, magicmnbuy;
double slh4, tph4, tph4am, sld1, tpd1, slw, tpw, tpwam, slmn, tpmn, tpmnam;
datetime order_date_h4, order_date_w;
MqlTradeRequest request_;
MqlTradeResult result_;
static double volume; 
double rhigh, slow;
int OnInit()
 {
//--- create timer
   magich4buy = 11; magich4sell = 12; magicd1buy = 21; magicd1sell = 22; magicwbuy = 31; magicwsell = 32;
   magicmnsell = 41; magicmnbuy = 42;
   slh4 = 500000.0; tph4 = 350000; sld1 = 500000; tpd1 = 1000000; slw = 500000; tpw = 1000000; 
   tph4am = 1000000; tpwam = 3000000; slmn = 500000; tpmn = 100000; tpmnam = 5000000;
   rhigh = 0; slow = 0;
   ZeroMemory(request_);
   volume = 0.2;
   EventSetTimer(60);
   bahighlowhandel = iCustom(_Symbol,PERIOD_D1,"BaHighLow");
   if(bahighlowhandel==INVALID_HANDLE)
      return(INIT_FAILED);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- destroy timer
   EventKillTimer();
   IndicatorRelease(bahighlowhandel);
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
// Indicator data
 
   double support[], resistance[];
   int i = CopyBuffer(bahighlowhandel, 0, 1, 50, support);
   int j = CopyBuffer(bahighlowhandel, 1, 1, 50, resistance);
   ArraySetAsSeries(support, true);
   ArraySetAsSeries(resistance, true);
   datetime date = TimeCurrent();
   if(!IsEnvelopingHour(PERIOD_CURRENT, date))
     {
      slow = iLow(_Symbol,PERIOD_CURRENT,0);
      rhigh = iHigh(_Symbol, PERIOD_CURRENT,0);
     }
   if(i > 0){
      switch(_Period)
        {
         case PERIOD_H4 :
           if(signal(PERIOD_H4,magich4buy, request_, result_,tph4,slh4,ORDER_TYPE_BUY,volume, support, resistance, rhigh, slow))
             {
              order_date_h4 = TimeCurrent()-200;
              printf("requet envoyé");
             }
           break;
         case PERIOD_D1 :
           if(signal(PERIOD_D1,magicd1buy, request_, result_,tpd1,sld1,ORDER_TYPE_BUY, volume, support, resistance, rhigh, slow))
             {
              printf("requet envoyé");
             }
           break;
         case PERIOD_W1 :
            if(signal(PERIOD_W1,magicwbuy, request_, result_,tpw,slw,ORDER_TYPE_BUY, volume, support, resistance, rhigh, slow))
             {
              order_date_w = TimeCurrent() - 200;
              printf("requet envoyé");
             }
           break;
         case PERIOD_M1 :
           break;
         default:
           break;
        }
     }
   if(j > 0)
     {
      switch(_Period)
        {
         case PERIOD_H4 :
           if(signal(PERIOD_H4,magich4sell, request_, result_,tph4,slh4,ORDER_TYPE_SELL,volume,support, resistance,rhigh, slow))
             {
              order_date_h4 = TimeCurrent()-200;
              printf("requet envoyé");
             }
           break;
         case PERIOD_D1 :
           if(signal(PERIOD_D1,magicd1sell, request_, result_,tpd1,sld1,ORDER_TYPE_SELL, volume,support, resistance, rhigh, slow))
             {
              printf("requet envoyé");
             }
           break;
         case PERIOD_W1 :
            if(signal(PERIOD_W1,magicwsell, request_, result_,tpw,slw,ORDER_TYPE_BUY, volume,support, resistance, rhigh, slow))
             {
              order_date_w = TimeCurrent()-200;
              printf("requet envoyé");
             }
           break;
         case PERIOD_M1 :   
           break;
         default:
           break;
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
   if(checkdealByMagic(magicd1buy,order_date_w, price))
     {
      printf("Ok");
     }
   /*double price;
   if(_Period == PERIOD_H4)
     {
      if(checkdealByMagic(magich4buy,order_date_h4,price))
        {
         request.action = TRADE_ACTION_DEAL;
         request.symbol = _Symbol;
         request.deviation = 5;
         request.volume = volume;
         request.type = ORDER_TYPE_BUY;
         request.price = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
         request.sl = price;
         request.tp = SymbolInfoDouble(_Symbol,SYMBOL_ASK) + tph4am*_Point;
         request.magic = magic;
        }
        else
          {
           if(checkdealByMagic(magich4sell,order_date_h4,price))
           {
            request.action = TRADE_ACTION_DEAL;
            request.symbol = _Symbol;
            request.deviation = 5;
            request.volume = volume;
            request.type = ORDER_TYPE_SELL;
            request.price = SymbolInfoDouble(_Symbol,SYMBOL_BID);
            request.sl = price;
            request.tp = SymbolInfoDouble(_Symbol,SYMBOL_BID) + tph4am*_Point;
            request.magic = magic;
           }
          }
     }
     
     if(_Period == PERIOD_W1)
     {
      if(checkdealByMagic(magicwbuy,order_date_w,price))
        {
         request.action = TRADE_ACTION_DEAL;
         request.symbol = _Symbol;
         request.deviation = 5;
         request.volume = volume;
         request.type = ORDER_TYPE_BUY;
         request.price = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
         request.sl = price;
         request.tp = SymbolInfoDouble(_Symbol,SYMBOL_ASK) + tpwam*_Point;
         request.magic = magic;
        }
        else
          {
           if(checkdealByMagic(magich4sell,order_date_h4,price))
           {
            request.action = TRADE_ACTION_DEAL;
            request.symbol = _Symbol;
            request.deviation = 5;
            request.volume = volume;
            request.type = ORDER_TYPE_SELL;
            request.price = SymbolInfoDouble(_Symbol,SYMBOL_BID);
            request.sl = price;
            request.tp = SymbolInfoDouble(_Symbol,SYMBOL_BID) + tpwam*_Point;
            request.magic = magic;
           }
          }
     }
   */
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
   bahighlowhandel = iCustom(_Symbol,PERIOD_D1,"BaHighLow");
   if(bahighlowhandel==INVALID_HANDLE)
      return ;
//---
   return ;
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
   EventKillTimer();
   IndicatorRelease(bahighlowhandel);
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

bool checksignalforsupport(double &support[], double price, double body, double slow_){
   int size = ArraySize(support);
   for(int i=0;i<size;i++)
     {
      if(support[i] > price && support[i]!=EMPTY_VALUE && body > 1000000*_Point)
        {
         return true;
        }
     }
     return false;
}

bool checksignalforresistance(double &resistance[], double price, double body, double rhigh_){
   int size = ArraySize(resistance);
   for(int i=0;i<size;i++)
     {
      if(resistance[i] < price && resistance[i]!=EMPTY_VALUE && body > 1000000*_Point)
        {
         return true;
        }
     }
     return false;
}

int signal(
         ENUM_TIMEFRAMES period,
         int magic,
         MqlTradeRequest &request,
         MqlTradeResult &result,
         double slpips,
         double tppips,
         ENUM_ORDER_TYPE type,
         double volume_,
         double &support[],
         double &resistance[],
         double rhigh_,
         double slow_
           ){
   
   datetime time =  TimeCurrent();
   int res = 0;
   if(IsEnvelopingHour(period,time))
           {
            double low = iLow(_Symbol,period, 0);
            double price = iClose(_Symbol, period, 0);
            double high = iHigh(_Symbol, period, 0);
            double body = high - price;
            if(checksignalforsupport(support, price, body, slow_)
               &&!checkOpenByMagic(magic)){
               request.action = TRADE_ACTION_DEAL;
               request.symbol = _Symbol;
               request.deviation = 5;
               request.volume = volume;
               request.type = type;
               request.price = SymbolInfoDouble(_Symbol,SYMBOL_BID);
               request.sl = SymbolInfoDouble(_Symbol,SYMBOL_BID) - _Point*slpips;
               request.tp = SymbolInfoDouble(_Symbol,SYMBOL_BID) + tppips*_Point;
               request.magic = magic;
               if(OrderSend(request, result))
                 {
                  return 1;
                 } 
            }
            if(checksignalforresistance(resistance, price, body, rhigh_)
               &&!checkOpenByMagic(magic)){
               request.action = TRADE_ACTION_DEAL;
               request.symbol = _Symbol;
               request.deviation = 5;
               request.volume = volume;
               request.type = type;
               request.price = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
               request.sl = SymbolInfoDouble(_Symbol,SYMBOL_ASK) + _Point*slpips;
               request.tp = SymbolInfoDouble(_Symbol,SYMBOL_ASK) - tppips*_Point;
               request.magic = magic;
               if(OrderSend(request, result))
                 {
                  return -1;
                 } 
            }
           }
   return res;
}

import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/additional_infoitem.dart';
import 'package:weather/city_search.dart';
import 'hourly_forecast_widget.dart';
import 'package:http/http.dart' as http;


class WheatherScreen extends StatefulWidget {
  const WheatherScreen({super.key});

  @override
  State<WheatherScreen> createState() => _WheatherScreenState();
}

class _WheatherScreenState extends State<WheatherScreen> {
  
  
  @override
  void initState(){
    super.initState();
    getCurrentWheather();
  }
  
  String cityName ="Rajkot";
  Future<Map<String,dynamic>> getCurrentWheather() async {
    try{  
      String apiKey = dotenv.env['API_KEY'] ?? 'API not found';
      final res= await http.get(
      Uri.parse('https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$apiKey'), 
      );

      final data=jsonDecode(res.body);

      if(data['cod']!='200'){
        throw "A unexpected error occured";
      }

      
      return data;
    }
    catch(e){
      throw e.toString();
    }   
  }
  void updateCity(String newCity) {
    setState(() {
      cityName = newCity; // Update the city name
      getCurrentWheather(); // Fetch new weather data
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      
      appBar: AppBar(
        title: const Text('Wheather App',style: TextStyle(
           fontWeight: FontWeight.bold
        ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: (){
              setState(() {
                
              });
            },
             icon: Icon(Icons.refresh),
             )
        ],
      ),

      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: FutureBuilder(
          future: getCurrentWheather(),
          builder:(context, snapshot) {
        
            if(snapshot.connectionState==ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator());
            }
            if(snapshot.hasError){
              return Center(child: Text(snapshot.error.toString()));
            }
        
            final data=snapshot.data!;
            
            final currentTemp = (data['list'][0]['main']['temp'] - 273.15).toStringAsFixed(0); // Convert to Celsius and format as string
            final currentSky=data['list'][0]['weather'][0]['main'];
            final currentPressure=data['list'][0]['main']['pressure'];
            final currentWindSpeed=data['list'][0]['wind']['speed'];
            final currentHumidity=data['list'][0]['main']['humidity'];
        
        
            return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CitySearch(onCitySelected: updateCity),

                Row(
                  children: [
                    Icon(Icons.location_on_rounded),
                    Text(cityName,style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),),
                  ],
                ),
                
                
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 50, 
                   shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                   ),
                   
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10,sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text('$currentTemp°',style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 32,
                              ),),
                              const SizedBox(height: 10),
                              Icon(currentSky=='Clouds' || currentSky=='Rain'?
                                Icons.cloud:Icons.sunny,
                              size: 60,),
                              const SizedBox(height: 10,),
                               Text('$currentSky',style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),)
                          
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height:20,),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Wheather Forecast',style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  
                  ),),
                ),
                
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //     children: [
                //       HourlyForeCastWidget(
                //         icon: Icons.cloud,
                //         time: "3:00",
                //         temp: "100",
                //       ),
                //       HourlyForeCastWidget(
                //         icon: Icons.cloud,
                //         time: "8:00",
                //         temp: "100",
                //       ),
                //       HourlyForeCastWidget(
                //         icon: Icons.cloud,
                //         time: "5:00",
                //         temp: "100",
                //       ),
                //       HourlyForeCastWidget(
                //         icon: Icons.cloud,
                //         time: "2:00",
                //         temp: "100",
                //       ),
                //     ],
                //   ),
                // ),
        
                SizedBox(
                  height: 135,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    
                    itemCount: 10,
                    itemBuilder: (context,index){
                  
                      final hourForecast=data['list'][index+1];
                      final hourSky=data['list'][index+1]['weather'][0]['main'];
                      final time=DateTime.parse(hourForecast['dt_txt']);
                      
                  
                      return HourlyForeCastWidget(
                          time: DateFormat.j().format(time),
                          icon: hourSky=='Clouds' || hourSky=='Rain'?
                                  Icons.cloud:Icons.sunny,
                          temp: (hourForecast['main']['temp']-273.15).toStringAsFixed(0)+'°',
                      );
                    }
                  ),
                ),
           
                const SizedBox(height: 20,),
                Text('Additional Information',style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),),
                const SizedBox(height: 8,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                      AdditionalInfoitem(
                        icon: Icons.water_drop,
                        label: 'Hubidity',
                        value: currentHumidity.toString(),
                      ),
                      AdditionalInfoitem(
                        icon: Icons.air,
                        label: 'Wind Power',
                        value: currentWindSpeed.toString(),
                      ),
                      AdditionalInfoitem(
                        icon: Icons.wind_power,
                        label: 'Pressure',
                        value: currentPressure.toString(),
                      ),
                    
                  ],
                )
          
          
          
          
              ],
            ),
          );
          },
        ),
      ),


    );
  }
}


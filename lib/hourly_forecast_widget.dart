import 'package:flutter/material.dart';

class HourlyForeCastWidget extends StatelessWidget {

  final IconData icon;
  final String time;
  final String temp;
  const HourlyForeCastWidget({
    super.key,
    required this.time,
    required this.icon,
    required this.temp,
    });

  @override
  Widget build(BuildContext context) {
      return SizedBox(
        height: 150,
        child: Card(
                      elevation: 20,
                      child: Container(
                        width: 100,
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            Text(time,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold, 
                              
                            ),),
                            const SizedBox(height: 10,),
                            Icon(icon,size: 30,),
                            const SizedBox(height: 10,),
                            Text(temp)
                        
                          ],
                        ),
                      ),
                    ),
      );
  }
}
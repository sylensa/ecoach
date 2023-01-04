import 'dart:convert';

import 'package:ecoach/database/database.dart';
import 'package:ecoach/database/glossary_db.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/glossary_model.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:sqflite/sqflite.dart';

class GlossaryController{
  
  
  getGlossariesList(Batch batch,int courseId)async{
    // await GlossaryDB().deleteAll();
    var response = await  doGet("${AppUrl.glossaries}?course_id=$courseId");
    print("glossary response:${response}");

    if(response["status"] && response["code"] == "200" && response["data"].isNotEmpty){
      for(int i =0; i < response["data"].length; i++){
        GlossaryData glossaryData = GlossaryData.fromJson(response["data"][i]);
        glossaryData.glossary = jsonEncode(response["data"][i]);
        await GlossaryDB().insert(batch,glossaryData);
      }
    }else{
      print("Nothing");
    }
  }
  getGlossariesTopicList(Batch batch,var courseId,List topicIds)async{
    // await GlossaryDB().deleteAll();
    Map<String, dynamic> body = {
      "course_id" :"$courseId",
      "topic_ids":jsonEncode(topicIds)
    };
    String urlString = AppUrl.glossaries + '?' + Uri(queryParameters: body).query;
    print(jsonEncode(body));
    var response = await  doGet("$urlString");
    print("glossary topicx response:${response["data"].length}");
    if(response["status"] && response["code"] == "200" && response["data"].isNotEmpty){
      for(int i =0; i < response["data"].length; i++){
        GlossaryData glossaryData = GlossaryData.fromJson(response["data"][i]);
        glossaryData.glossary = jsonEncode(response["data"][i]);
        await GlossaryDB().insertTopicGlossary(batch,glossaryData);
      }
    }else{
      print("Nothing");
    }
  }
  getUserSavedGlossariesList()async{
    List<GlossaryData> listGlossaryData = [];
    var response = await  doGet("${AppUrl.savedGlossaries}");
    if(response["status"] && response["code"] == "200" && response["data"]["data"].isNotEmpty){
      for(int i =0; i < response["data"]["data"].length; i++){
        GlossaryData glossaryData = GlossaryData.fromJson(response["data"]["data"][i]["glossary"]);
        glossaryData.glossary = jsonEncode(response["data"]["data"][i]["glossary"]);
        glossaryData.definition = response["data"]["data"][i]["glossary"]["definitions"][0]["definition"];
        glossaryData.courseId = response["data"]["data"][i]["glossary"]["course_id"];
        listGlossaryData.add(glossaryData);
      }
    }

    return listGlossaryData;
  }
  getUserLikedGlossariesList(Batch batch,int courseId)async{
    var response = await  doGet("${AppUrl.likedGlossaries}");
    if(response["status"] && response["code"] == "200" && response["data"].isNotEmpty){
      for(int i =0; i < response["data"].length; i++){
        GlossaryData glossaryData = GlossaryData.fromJson(response["data"][i]);
        glossaryData.glossary = jsonEncode(response["data"][i]);
        await GlossaryDB().insert(batch,glossaryData);
      }
    }
  }

  getPersonalisedGlossariesList()async{
    List<GlossaryData> listGlossaryData = [];
    var response = await  doGet("${AppUrl.personalizedGlossaries}");
    if(response["status"] && response["code"] == "200" && response["data"]["data"].isNotEmpty){
      for(int i =0; i < response["data"]["data"].length; i++){
        GlossaryData glossaryData = GlossaryData.fromJson(response["data"]["data"][i]);
        glossaryData.glossary = jsonEncode(response["data"]["data"][i]);
        listGlossaryData.add(glossaryData);
      }
    }else{
      print("nothing");
    }
    return listGlossaryData;
  }
  saveGlossariesList(GlossaryData glossaryData)async{
    if(isTopicSelected){
      await GlossaryDB().updateGlossaryTopic(glossaryData);
    }else{
      await GlossaryDB().update(glossaryData);
    }
    var response = await  doPost("${AppUrl.saveGlossaries}",{
      "glossary_id" : glossaryData.id
    });
    if(response["status"] && response["code"] == "200"){
      toastMessage(response["message"]);
        // glossaryData.isSaved = 1;

    }

    return glossaryData;
  }
  unSaveGlossariesList(GlossaryData glossaryData)async{
    if(isTopicSelected){
      await GlossaryDB().updateGlossaryTopic(glossaryData);
    }else{
      await GlossaryDB().update(glossaryData);
    }
    var response = await  doPost("${AppUrl.unSaveGlossaries}",{
      "glossary_id" : glossaryData.id
    });
    if(response["status"] && response["code"] == "200"){
      toastMessage(response["message"]);
        // glossaryData.isSaved = 0;
    }

    return glossaryData;
  }

  likeGlossariesList(GlossaryData glossaryData)async{
    var response = await  doPost("${AppUrl.likeGlossaries}",{
      "glossary_id" : glossaryData.id
    });
    if(response["status"] && response["code"] == "200"){
      toastMessage(response["message"]);
      glossaryData.isLiked = 1;
      await GlossaryDB().update(glossaryData);
    }

    return glossaryData;
  }
  unLikeGlossariesList(GlossaryData glossaryData)async{
    var response = await  doPost("${AppUrl.unLikeGlossaries}",{
      "glossary_id" : glossaryData.id
    });
    if(response["status"] && response["code"] == "200"){
      toastMessage(response["message"]);
      glossaryData.isLiked = 0;
      await GlossaryDB().update(glossaryData);
    }

    return glossaryData;
  }
  createGlossary(Map body)async{
    GlossaryData? glossaryData;
    var response = await  doPost("${AppUrl.createGlossaries}",body);
    if(response["status"] && response["code"] == "200"){
      glossaryData = GlossaryData.fromJson(response["data"]);
    }
    return glossaryData;
  }
  updateGlossary(Map body)async{
    GlossaryData? glossaryData;
    var response = await  doPost("${AppUrl.updateGlossaries}",body);
    if(response["status"] && response["code"] == "200"){
      glossaryData = GlossaryData.fromJson(response["data"]);
    }
    return glossaryData;
  }

  pinUnPinGlossaries(GlossaryData glossaryData,bool pin)async{
    GlossaryData? glossary;
    var response = await  doPost("${AppUrl.pinUnPinGlossaries}",{
      "glossary_id" : glossaryData.id,
      "is_pinned" : pin,
    });
    if(response["status"] && response["code"] == "200"){
      toastMessage(response["message"]);
      glossary = GlossaryData.fromJson(response["data"]);
      return glossary;
    }

    return glossary;
  }

  deleteGlossaries(int glossaryId)async{
    var response = await  doDelete("${AppUrl.deleteGlossaries}/$glossaryId");
    if(response["status"] && response["code"] == "200"){
     return true;
    }
    return false;
  }
}
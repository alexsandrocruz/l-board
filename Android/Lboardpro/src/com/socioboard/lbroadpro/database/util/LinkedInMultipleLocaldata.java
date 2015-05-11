package com.socioboard.lbroadpro.database.util;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

public class LinkedInMultipleLocaldata extends SQLiteOpenHelper {

	public static final String db_name = "linkedinmultiple.db";

	public static final String table_name = "linkedinmultipletable";

	public static final String KEY_UserID = "userid";

	public static final String KEY_Username = "username";
	
	public static final String KEY_Userlastname = "lastname";
	
	public static final String KEY_UserEmailId = "useremailid";
	
	public static final String KEY_UserHeadline = "headline";

	public static final String KEY_UserAcessToken = "useracesstoken";
	
	public static final String KEY_Userimage="userimage";

	public LinkedInMultipleLocaldata(Context context) {

		super(context, db_name, null, 1);
		// TODO Auto-generated constructor stub
	}

	@Override
	public void onCreate(SQLiteDatabase db) {
		// TODO Auto-generated method stub

	}

	@Override
	public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
		// TODO Auto-generated method stub
		onCreate(db);
	}

	public void CreateTable() {

		String querry = "CREATE TABLE IF NOT EXISTS " + table_name + "("
				+ KEY_UserID + " TEXT," + KEY_Userimage + " TEXT," + KEY_Username + " TEXT,"
				+ KEY_UserAcessToken + " TEXT,"
				+ KEY_Userlastname + " TEXT,"+ KEY_UserEmailId +" TEXT," + KEY_UserHeadline +" TEXT)";

		SQLiteDatabase database = this.getWritableDatabase();

		database.execSQL(querry);

		System.out.println("CreateTable " + querry);

	}

	public void addNewUserAccount(ModelUserDatas modelUserDatas) {

		// String query = "INSERT INTO " + table_name + "";
		SQLiteDatabase database = this.getWritableDatabase();

		ContentValues contentValues = new ContentValues();
		
		contentValues.put(KEY_UserID, modelUserDatas.getUserid());
		contentValues.put(KEY_Userimage, modelUserDatas.getUserimage());
		contentValues.put(KEY_Username, modelUserDatas.getUsername());
		contentValues.put(KEY_UserAcessToken,modelUserDatas.getUserAcessToken());
		contentValues.put(KEY_Userlastname, modelUserDatas.getLastname());
		contentValues.put(KEY_UserEmailId, modelUserDatas.getUseremailid());
		contentValues.put(KEY_UserHeadline, modelUserDatas.getUserheadline());
		
		database.insert(table_name, null, contentValues);

		System.out.println("addNewUserAccount " + contentValues);

	}

	public ModelUserDatas getUserData(String userId) {

		ModelUserDatas modelUserDatas = null;

		String query = "SELECT * FROM " + table_name + " WHERE " + KEY_UserID
				+ " = '" + userId+ "'";

		SQLiteDatabase database = this.getReadableDatabase();

		Cursor cursor = database.rawQuery(query, null);

		if (cursor.moveToFirst()) {

			modelUserDatas = new ModelUserDatas();
			modelUserDatas.setUserid(cursor.getString(0));
			modelUserDatas.setUserimage(cursor.getString(1));
			modelUserDatas.setUsername(cursor.getString(2));
			modelUserDatas.setUserAcessToken(cursor.getString(3));
			
			modelUserDatas.setLastname(cursor.getString(4));
			modelUserDatas.setUseremailid(cursor.getString(5));
			modelUserDatas.setUserheadline(cursor.getString(6));
		}

		return modelUserDatas;
	}

	public void getAllUsersData() {

		String query = "SELECT * FROM " + table_name;

		System.out.println(query);

		SQLiteDatabase database = this.getReadableDatabase();

		Cursor cursor = database.rawQuery(query, null);

		ModelUserDatas modelUserDatas;
		MainSingleTon.userdetails.clear();
		MainSingleTon.useridlist.clear();
		if (cursor.moveToFirst()) {

			do {

				modelUserDatas = new ModelUserDatas();
				modelUserDatas.setUserid(cursor.getString(0));
				modelUserDatas.setUserimage(cursor.getString(1));
				modelUserDatas.setUsername(cursor.getString(2));
				modelUserDatas.setUserAcessToken(cursor.getString(3));
				
				modelUserDatas.setLastname(cursor.getString(4));
				modelUserDatas.setUseremailid(cursor.getString(5));
				modelUserDatas.setUserheadline(cursor.getString(6));
				
				MainSingleTon.useridlist.add(cursor.getString(0));
				MainSingleTon.userdetails.put(cursor.getString(0), modelUserDatas);
				

			} while (cursor.moveToNext());
		}

		
	}

	public void updateUserData(ModelUserDatas modelUserDatas) {

		SQLiteDatabase database = this.getWritableDatabase();

		String updateQuery = "UPDATE " + table_name + " SET "
		+ KEY_Userimage+ " = '" + modelUserDatas.getUserimage() + "' , "
		+ KEY_Username+ " = '" + modelUserDatas.getUsername()+"' , "
		+ KEY_UserAcessToken + " = '" + modelUserDatas.getUserAcessToken() + "' " 
		+ KEY_Userlastname + " = '" +modelUserDatas.getLastname() + "' "
		+ KEY_UserEmailId + " = '" +modelUserDatas.getUseremailid() + "' "
		+ KEY_UserHeadline + " = '" +modelUserDatas.getUserheadline() + "' " + " WHERE "
		+ KEY_UserID + " = '" + modelUserDatas.getUserid() + "'";

		System.out.println(updateQuery);

		database.execSQL(updateQuery);
	}
	
	public void updateUserAccessToken(String accesstoken, String userId)
	{
		SQLiteDatabase db = this.getWritableDatabase();
		
		String Updatequery = "UPDATE " + table_name + " SET "
				+ KEY_UserAcessToken + " = '" +accesstoken + "' " + " WHERE "
				+KEY_UserID + " = '" + userId + "'" ; 
		
		System.out.println("query ****** "+Updatequery);

		db.execSQL(Updatequery);
		
	}

	public void deleteAllRows() {

		SQLiteDatabase database = this.getWritableDatabase();

		String query = "DELETE FROM " + table_name;
		System.out.println(query);
		database.execSQL(query);
	}

	public void deleteThisUserData(String userID) 
	{

		SQLiteDatabase database = this.getWritableDatabase();

		String query = "DELETE FROM " + table_name + " WHERE " + KEY_UserID+ " = '" + userID+"'";
		System.out.println(query);
		database.execSQL(query);
	}

}

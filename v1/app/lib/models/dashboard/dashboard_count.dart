import 'dart:convert';

DashboardCount dashboardCountFromJson(String str) => DashboardCount.fromJson(json.decode(str));

String dashboardCountToJson(DashboardCount data) => json.encode(data.toJson());

class DashboardCount {
    DashboardCount({
        required this.totalUsers,
        required this.totalPlaces,
        required this.totalPlacesByCategory,
    });

    int totalUsers;
    int totalPlaces;
    List<TotalPlacesByCategory> totalPlacesByCategory;

    factory DashboardCount.fromJson(Map<String, dynamic> json) => DashboardCount(
        totalUsers: json["totalUsers"],
        totalPlaces: json["totalPlaces"],
        totalPlacesByCategory: List<TotalPlacesByCategory>.from(json["totalPlacesByCategory"].map((x) => TotalPlacesByCategory.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "totalUsers": totalUsers,
        "totalPlaces": totalPlaces,
        "totalPlacesByCategory": List<dynamic>.from(totalPlacesByCategory.map((x) => x.toJson())),
    };
}

class TotalPlacesByCategory {
    TotalPlacesByCategory({
        required this.id,
        required this.count,
    });

    String id;
    int count;

    factory TotalPlacesByCategory.fromJson(Map<String, dynamic> json) => TotalPlacesByCategory(
        id: json["_id"],
        count: json["count"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "count": count,
    };
}

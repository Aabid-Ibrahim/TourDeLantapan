class Photo {
  Photo({
    this.thumbnail,
    this.small,
    this.medium,
    this.large,
    this.original,
  });

  String? thumbnail;
  String? small;
  String? medium;
  String? large;
  String? original;

  factory Photo.fromJson(Map<String, dynamic> json) => Photo(
        thumbnail: json["thumbnail"],
        small: json["small"],
        medium: json["medium"],
        large: json["large"],
        original: json["original"],
      );

  Map<String, dynamic> toJson() => {
        "thumbnail": thumbnail,
        "small": small,
        "medium": medium,
        "large": large,
        "original": original,
      };
}

@interface BaseSchema : NSObject {
@protected
  __strong NSMutableArray *subSchemas;
  __strong NSMutableArray *preValidators;
  __strong NSMutableArray *postValidators;
}

@property (nonatomic, retain) NSString *schemaType;

-(BOOL) shouldValidate:(id)json;
-(void) validate:(id)json error:(NSError *__autoreleasing *)error;

-(NSArray<BaseSchema*>*) getSubSchemas;
-(void) addSubSchema:(BaseSchema*)subSchema;

-(void) addPreValidator:(BaseSchema*)preValidator;
-(void) preValidate:(id)json error:(NSError *__autoreleasing *)error;

-(void) addPostValidator:(BaseSchema*)postValidator;
-(void) postValidate:(id)json error:(NSError *__autoreleasing *)error;

@end

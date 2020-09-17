//
//  ViewController.m
//  Demo-ChatBot
//
//  Created by Imac  on 08/11/19.
//  Copyright © 2019 Global Corporation. All rights reserved.
//

#import "ChatLogController.h"

@interface ChatLogController ()

@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) NSString *id_chat;
@property (nonatomic, strong) UITapGestureRecognizer *tapToDismissKeyboard;
@property (nonatomic, strong) NSMutableArray *historicalMessages;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSNumber *id_usuario;
@property (nonatomic, strong) NSString *nombre;

@end

@implementation ChatLogController

BOOL viewDidLayoutSubviewsForTheFirstTime = YES;

# pragma mark: - Init

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViewComponents];
    self.id_usuario = @57;
    self.nombre = @"Alberto";
    self.array = [[NSMutableArray alloc] init];
    self.historicalMessages = [[NSMutableArray alloc] init];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss dd-MM-YYYY"];
    self.date = [dateFormatter stringFromDate:[NSDate date]];
}

//- (void)viewWillAppear:(BOOL)animated {
//    [self viewWillAppear:YES];
//
//    [self.view layoutIfNeeded];
//
//    CGSize contentSize = [self.collectionView.collectionViewLayout collectionViewContentSize];
//    if (contentSize.height > self.collectionView.bounds.size.height) {
//        CGPoint targetContentOffset = CGPointMake(0.0f, contentSize.height - self.collectionView.bounds.size.height);
//        [self.collectionView setContentOffset:targetContentOffset];
//    }
//}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setupTapGesture];
    [self setupKeyboardObservers];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:chatState] isEqualToString:@"1"]) {
        
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:chatState];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self startChat];
    }
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//- (void)viewDidLayoutSubviews {
//    [self.collectionView.collectionViewLayout collectionViewContentSize];
//    NSInteger item = [self.collectionView numberOfItemsInSection:0];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:item inSection:0];
//    [self.collectionView scrollToItemAtIndexPath:indexPath
//                                atScrollPosition:UICollectionViewScrollPositionBottom
//                                        animated:YES];
//}

# pragma mark: - Helper Functions

- (void)setupTapGesture {
    self.tapToDismissKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDismissKeyboard)];
    [self.view addGestureRecognizer:self.tapToDismissKeyboard];
}

- (void)setupViewComponents {
    /* Navigation Controller & items */
    [self.navigationItem setTitle:@"Chat"];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Finish"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(handleFinish)];
    
    /* Collection view */
    [self.collectionView setDelegate:self];
    [self.collectionView setDataSource:self];
    [self.collectionView setBackgroundColor:UIColor.whiteColor];
    [self.collectionView registerClass:[ChatCell class]
            forCellWithReuseIdentifier:@"reuseIdentifier"];
    self.collectionView.contentInset = UIEdgeInsetsMake(8, 0, 58, 0);
    self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 58, 0);
    self.collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    self.collectionView.contentOffset = CGPointMake(0, 58);
    [self.collectionView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.collectionView layoutIfNeeded];
    
    /* Container view */
    self.containerView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.containerView];
    [self.containerView setBackgroundColor:[UIColor colorNamed:@"grayColor"]];
    [self.containerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    
    [[self.containerView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor] setActive:YES];
    [[self.containerView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor] setActive:YES];
    
    if (@available (iOS 11, *)) {
        self.containerViewBottomAnchor = [self.containerView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor];
        [[self.containerView.heightAnchor constraintEqualToConstant:self.view.safeAreaInsets.bottom + 50] setActive:YES];
    } else {
        self.containerViewBottomAnchor = [self.containerView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor];
        [[self.containerView.heightAnchor constraintEqualToConstant:50] setActive:YES];
    }
    [self.containerViewBottomAnchor setActive:YES];
    
    /* Safe area */
    if (@available (iOS 11, *)) {
        UIView *safeAreaView = [[UIView alloc] init];
        [self.view addSubview:safeAreaView];
        [safeAreaView setBackgroundColor:[UIColor colorNamed:@"grayColor"]];
        [safeAreaView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [[safeAreaView.topAnchor constraintEqualToAnchor:self.containerView.bottomAnchor] setActive:YES];
        [[safeAreaView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor] setActive:YES];
        [[safeAreaView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor] setActive:YES];
        [[safeAreaView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor] setActive:YES];
    }
    
    /* Send button */
    self.sendButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.containerView addSubview:self.sendButton];
    [self.sendButton setTitle:@"Send"
                     forState:UIControlStateNormal];
    [self.sendButton addTarget:self
                        action:@selector(handleSend)
              forControlEvents:UIControlEventTouchUpInside];
    [self.sendButton setTranslatesAutoresizingMaskIntoConstraints:NO];
//    [self.sendButton setEnabled:NO];
    
    [[self.sendButton.rightAnchor constraintEqualToAnchor:self.containerView.rightAnchor
                                                 constant:-8] setActive:YES];
    [[self.sendButton.centerYAnchor constraintEqualToAnchor:self.containerView.centerYAnchor] setActive:YES];
    [[self.sendButton.heightAnchor constraintEqualToAnchor:self.containerView.heightAnchor] setActive:YES];
    [[self.sendButton.widthAnchor constraintEqualToConstant:80] setActive:YES];
    
    /* Messsage text field */
    self.messageTextField = [[UITextField alloc] init];
    [self.containerView addSubview:self.messageTextField];
    [self.messageTextField setPlaceholder:@"Message"];
    [self.messageTextField setBackgroundColor:UIColor.whiteColor];
    [self.messageTextField setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.messageTextField.layer setCornerRadius:20];
    [self.messageTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.messageTextField setDelegate:self];
    
    [[self.messageTextField.leftAnchor constraintEqualToAnchor:self.containerView.leftAnchor
                                                      constant:8] setActive:YES];
    [[self.messageTextField.centerYAnchor constraintEqualToAnchor:self.containerView.centerYAnchor] setActive:YES];
    [[self.messageTextField.heightAnchor constraintEqualToAnchor:self.containerView.heightAnchor multiplier:0.666] setActive:YES];
    [[self.messageTextField.rightAnchor constraintEqualToAnchor:self.sendButton.leftAnchor] setActive:YES];
    
    /* Separator line view */
    UIView *separatorLineView = [[UIView alloc] init];
    [self.containerView addSubview:separatorLineView];
    [separatorLineView setBackgroundColor:RGB(220, 220, 220)];
    [separatorLineView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [[separatorLineView.topAnchor constraintEqualToAnchor:self.containerView.topAnchor] setActive:YES];
    [[separatorLineView.widthAnchor constraintEqualToAnchor:self.containerView.widthAnchor] setActive:YES];
    [[separatorLineView.heightAnchor constraintEqualToConstant:1] setActive:YES];
    
}

- (void)setupKeyboardObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (CGRect)estimateFrameForText:(NSString *)text {
    CGFloat width = UIScreen.mainScreen.bounds.size.width * 0.666;
    CGSize size = CGSizeMake(width, 1000);
    NSStringDrawingOptions options = NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin;
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16]};
    NSString *string = [[NSString alloc] initWithString:text];
    
    return [string boundingRectWithSize:size
                                options:options
                             attributes:attributes
                                context:nil];
    
}

- (void)connectToSocket {
    NSString *url = @"wss://soporte360.ml";
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    self.webSocket = [PSWebSocket clientSocketWithRequest:urlRequest];
    self.webSocket.delegate = self;
    
    [self.webSocket open];
    
}

- (NSString *)sendRegisterMessage {
    NSDictionary *jsonDictionary = @{@"tipo":@"usuario",
                                     @"proyecto":@"Emergencias",
                                     @"id":self.id_usuario,
                                     @"nombre":self.nombre,
                                     @"action":@"register"
                                     };
    NSData *jsonSerializationData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                                                                    options:NSJSONWritingPrettyPrinted
                                                                      error:nil];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonSerializationData
                                                 encoding:NSUTF8StringEncoding];
    
    return jsonString;
}

- (NSString *)sendUnregisterMessage {
    NSDictionary *jsonDictionary = @{@"tipo":@"usuario",
                                     @"proyecto":@"Emergencias",
                                     @"id":self.id_usuario,
                                     @"id_char":self.id_chat,
                                     @"action":@"unregister"
                                     };
    NSData *jsonSerializationData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                                                                    options:NSJSONWritingPrettyPrinted
                                                                      error:nil];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonSerializationData
                                                 encoding:NSUTF8StringEncoding];
    
    return jsonString;
}

- (NSDictionary *)decodeReceivedMessage:(NSString *)message {
    NSData *jsonData = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                               options:0
                                                                 error:nil];
    return jsonObject;
}

- (void)reloadMessages:(NSMutableArray *)array {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSInteger item = [array count] - 1;
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
        [self.collectionView reloadData];
        [self.collectionView layoutIfNeeded];
        [self.collectionView scrollToItemAtIndexPath:indexPath
                                    atScrollPosition:UICollectionViewScrollPositionBottom
                                            animated:YES];
    });
}

- (void)disconnect {
    NSString *message = [self sendUnregisterMessage];
    [self.webSocket send:message];
    [self.webSocket close];
}

- (void)startChat {
    [self connectToSocket];
    [self sendRegisterMessage];
}

- (ChatCell *)filterMessages:(NSMutableArray *)messages at:(NSIndexPath *)indexPath toShowIn:(ChatCell *)cell {
    NSString *action = [[self.array objectAtIndex:indexPath.row] objectForKey:@"action"];
    NSString *message = [[self.array objectAtIndex:indexPath.row] objectForKey:@"mensaje"];
    NSString *nombre = [[self.array objectAtIndex:indexPath.row] objectForKey:@"nombre"];
    NSString *tipo = [[self.array objectAtIndex:indexPath.row] objectForKey:@"tipo"];
    NSNumber *id_usuario = [[self.array objectAtIndex:indexPath.row] objectForKey:@"id_usuario"];
    NSString *fechaRecibido = [[self.array objectAtIndex:indexPath.row] objectForKey:@"fechaRecibido"];
    NSString *horaRecibido = [[self.array objectAtIndex:indexPath.row] objectForKey:@"horaRecibido"];
    NSString *fechaHora = [NSString stringWithFormat:@"%@ %@", horaRecibido, fechaRecibido];
    NSString *horaEnviado = [[self.array objectAtIndex:indexPath.row] objectForKey:@"hora_enviado"];
    
    if ([action isEqualToString:@"historial"]) {
        cell.massageTextView.text = message;
        cell.dateLabel.text = fechaHora;
        if ([id_usuario isEqual:self.id_usuario]) {
            [cell.bubbleView setBackgroundColor:[UIColor colorNamed:@"grayBubbleColor"]];
            [cell.dateLeftAnchor setActive:NO];
            [cell.dateRightAnchor setActive:YES];
            [cell.bubbleLeftAnchor setActive:NO];
            [cell.bubbleRightAnchor setActive:YES];
        } else {
            [cell.bubbleView setBackgroundColor:[UIColor colorNamed:@"orangeBubbleColor"]];
            [cell.dateLeftAnchor setActive:YES];
            [cell.dateRightAnchor setActive:NO];
            [cell.bubbleLeftAnchor setActive:YES];
            [cell.bubbleRightAnchor setActive:NO];
        }
    } else if ([action isEqualToString:@"mensaje"] || [action isEqualToString:@"message"]) {
        cell.massageTextView.text = message;
        if ([tipo isEqual: @"usuario"]) {
            cell.dateLabel.text = horaEnviado;
            [cell.bubbleView setBackgroundColor:[UIColor colorNamed:@"grayBubbleColor"]];
            [cell.dateLeftAnchor setActive:NO];
            [cell.dateRightAnchor setActive:YES];
            [cell.bubbleLeftAnchor setActive:NO];
            [cell.bubbleRightAnchor setActive:YES];
        } else if ([nombre isEqual:@"servidor"] || [tipo isEqualToString:@"soporte"]){
            [cell.bubbleView setBackgroundColor:[UIColor colorNamed:@"orangeBubbleColor"]];
            [cell.dateLeftAnchor setActive:YES];
            [cell.dateRightAnchor setActive:NO];
            [cell.bubbleLeftAnchor setActive:YES];
            [cell.bubbleRightAnchor setActive:NO];
        }
    }
    
    cell.bubbleWidthAnchor.constant = [self estimateFrameForText:message].size.width + 32;
    
    return cell;
}

- (void)orderReceivedMessages:(NSDictionary *)message {
    if ([[message objectForKey:@"action"] isEqualToString:@"historial"]) {
        [self.historicalMessages addObject:message];
//        NSLog(@"Historico: %@", self.historicalMessages);
        NSArray *arrayDiasHistorial = [[NSArray alloc] init];
        NSString *key = [[NSString alloc] init];
        NSString *hora = [[NSString alloc] init];
        NSString *mensaje = [[NSString alloc] init];
        NSString *nombre = [[NSString alloc] init];
        NSNumber *id_usuario;
        arrayDiasHistorial = [[message objectForKey:@"listmensajes"] allKeys];
        for (int i = 0 ; i < [arrayDiasHistorial count]; i++) {
            key = [arrayDiasHistorial objectAtIndex:i];
            NSArray *arrayAux = [[NSArray alloc] init];
            arrayAux = [[message objectForKey:@"listmensajes"] objectForKey:key];
//            NSLog(@"%@ - %@", key, arrayAux);
            for (int j = 0; j < [arrayAux count]; j ++) {
                NSArray *aux = [[NSArray alloc] init];
                aux = arrayAux[j];
//                NSLog(@"Mensaje: %@", aux);
                for (int k = 0; k < [aux count]; k++) {
                    hora = aux[1];
                    mensaje = aux[2];
                    nombre = aux[3];
                    if (aux[4] != nil) {
                        id_usuario = aux[4];
                    } else {
                        id_usuario = 0;
                    }
//                    NSLog(@"Objeto: %@", aux[k]);
                    
                }
                
                NSDictionary *mensajeHistorico = @{@"action":@"historial",
                                                   @"fechaRecibido": key,
                                                   @"horaRecibido": hora,
                                                   @"id_usuario": id_usuario,
                                                   @"mensaje": mensaje,
                                                   @"nombre": nombre
                                                   };
//                NSLog(@"Diccionario creado:%@",mensajeHistorico);
                [self.array addObject:mensajeHistorico];
                NSInteger count = [self.array count];
                for (int x = 0; x < count; x++) {
                    NSDictionary *dict = self.array[x];
                    if ([[dict objectForKey:@"mensaje"] isEqualToString:@"Desconectado"]) {
                        [self.array removeObjectAtIndex:x];
                    }
                }
                [self removeDuplicates:self.array];
            }
            
        }
//        NSLog(@"%@", self.array);
        NSDictionary *dict = [self.array lastObject];
        NSString *msj = [NSString stringWithFormat:@"Hola %@ ¿En que te puedo ayudar?", self.nombre];
        if ([[dict objectForKey:@"mensaje"] isEqualToString:msj]) {
            [self.array removeLastObject];
        }
//        NSLog(@"ULTIMO OBJETO: %@", dict);
    } else if ([[message objectForKey:@"action"] isEqualToString:@"mensaje"]) {
        [self.array addObject:message];
        self.id_chat = [message objectForKey:@"id_chat"];
    }
}

- (void)removeDuplicates:(NSMutableArray *)array {
    NSMutableArray *arrayAuxiliar = [[NSMutableArray alloc] init];
    NSString *mensaje = [NSString stringWithFormat:@"Hola %@ ¿En que te puedo ayudar?", self.nombre];
    for (int i = 0; i < [array count]; i++) {
        NSDictionary *dict = array[i];
        if ([[dict objectForKey:@"mensaje"] isEqualToString:mensaje]) {
            NSNumber *objeto = [NSNumber numberWithInt:i];
            [arrayAuxiliar addObject:objeto];
        }
    }
//    NSLog(@"ARRAY AUXILIAR: %@", arrayAuxiliar);
    
    for (int i = 1; i < [arrayAuxiliar count]; i++) {
        NSNumber *valorActual = arrayAuxiliar[i];
        NSNumber *valorAnterior = arrayAuxiliar[i - 1];
        int vActual = [valorActual intValue];
        int vAnterior = [valorAnterior intValue];
        int vSuma = vAnterior + 1;
        for (int j = vActual; j < [array count]; j++) {
            if (vActual == vSuma) {
                [array removeObjectAtIndex:vSuma];
            }
        }
    }
    
}

- (NSString *)getDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss dd-MM-YYYY"];
    NSString *date = [dateFormatter stringFromDate:[NSDate date]];
    return date;
}

# pragma mark: - Selectors

- (void)handleSend {
    NSString *message = self.messageTextField.text;
    if ([message isEqualToString:@""]) {
        NSLog(@"Invalid");
    } else {
        self.date = [self getDate];
        NSDictionary *newMessage = @{@"tipo": @"usuario",
                                     @"proyecto": @"Emergencias",
                                     @"mensaje": message,
                                     @"action": @"message",
                                     @"id_chat": self.id_chat,
                                     @"id": self.id_usuario,
                                     @"hora_enviado":self.date
                                     };
        
        NSData *jsonSerializationData = [NSJSONSerialization dataWithJSONObject:newMessage
                                                                    options:NSJSONWritingPrettyPrinted
                                                                      error:nil];
        
        NSString *jsonToString = [[NSString alloc] initWithData:jsonSerializationData
                                                       encoding:NSUTF8StringEncoding];
        
        
        [self.array addObject:newMessage];
        [self.webSocket send:jsonToString];
        [self reloadMessages: self.array];
        [self.messageTextField setText:nil];
        NSLog(@"Sending %@", message);
    }
}

- (void)handleKeyboardWillShow:(NSNotification *)notification {
    
    CGSize keyboardHeight = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSTimeInterval keyboardDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    if (@available (iOS 11, *)) {
        self.containerViewBottomAnchor.constant = -keyboardHeight.height + self.view.safeAreaInsets.bottom;
    } else {
        self.containerViewBottomAnchor.constant = -keyboardHeight.height;
    }
    
    NSInteger item = [self.collectionView numberOfItemsInSection:0] - 1;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:item inSection:0];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView scrollToItemAtIndexPath:indexPath
                                    atScrollPosition:UICollectionViewScrollPositionBottom
                                            animated:YES];
    });
    
    [UIView animateWithDuration:keyboardDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)handleKeyboardWillHide:(NSNotification *)notification {
    NSTimeInterval keyboardDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    self.containerViewBottomAnchor.constant = 0;
    
    [UIView animateWithDuration:keyboardDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)handleDismissKeyboard {
    [self.messageTextField resignFirstResponder];
}

- (void)handleFinish {
    [self disconnect];
    [self.array removeAllObjects];
    [self.view.window endEditing:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
    [self viewDidDisappear:YES];
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:chatState];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)handleBack {
    NSLog(@"Prueba");
    [self.navigationController popViewControllerAnimated:YES];
    [self handleDismissKeyboard];
}

# pragma mark: - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.array count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ChatCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"reuseIdentifier"
                                                               forIndexPath:indexPath];
    
    cell = [self filterMessages:self.array
                             at:indexPath
                       toShowIn:cell];
    
    return cell;
}

# pragma mark: - UICollectionViewDelegate

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [self.collectionViewLayout invalidateLayout];
}

# pragma mark: - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 80;
    CGFloat width = self.view.frame.size.width;
    
    NSString *text = [[self.array objectAtIndex:indexPath.row] objectForKey:@"mensaje"];
    
    if (text != nil) {
        height = [self estimateFrameForText:text].size.height + 20;
    }
    
    
    return CGSizeMake(width, height + 20);
}

# pragma mark: - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self handleSend];
    return YES;
}

# pragma mark: - PSWebSocketDelegate

- (void)webSocket:(PSWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"The socket closed with code: %@, reason: %@, was clean: %@", @(code), reason, (wasClean) ? @"YES" : @"NO");
}

- (void)webSocket:(PSWebSocket *)webSocket didFailWithError:(NSError *)error {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:@"Ha ocurrido un error, por favor vuelva a iniciar el chat"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Finalizar"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       [self.navigationController popViewControllerAnimated:YES];
                                                       [self handleFinish];
                                                   }];
    
    [alert addAction:action];
    
    [self presentViewController:alert
                       animated:YES
                     completion:nil];
    
    NSLog(@"The socket connection failed with error %@", error);
}

- (void)webSocket:(PSWebSocket *)webSocket didReceiveMessage:(id)message {
    message = (NSString *)message;
    NSDictionary *json = [self decodeReceivedMessage:message];
    NSDictionary *receivedMessage = [[NSDictionary alloc] initWithDictionary:json];
    [self orderReceivedMessages:receivedMessage];
    [self reloadMessages:self.array];
    NSLog(@"The socket received a message %@", message);
}

- (void)webSocketDidOpen:(PSWebSocket *)webSocket {
    NSLog(@"Web socket opened...");
    NSString *message = [self sendRegisterMessage];
    [webSocket send:message];
}

# pragma mark: - Singleton Class

+ (ChatLogController *)sharedClass {
    static ChatLogController *sharedClass = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClass = [[self alloc] init];
    });
    return sharedClass;
}

@end

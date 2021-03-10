unit MatchingBodyContentTests;

interface

uses
  DUnitX.TestFramework,
  System.Net.HttpClient,
  WebMock;

type
  [TestFixture]
  TMatchingBodyContentTests = class
  private
    Client: THTTPClient;
    WebMock: TWebMock;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure StubRequest_MatchingBodyContentString_RespondsOK;
    [Test]
    procedure StubRequest_MatchingBodyContentRegEx_RespondsOK;
    [Test]
    procedure StubRequest_MatchingFormDataString_RespondsOK;
    [Test]
    procedure StubRequest_MatchingFormDataExistence_RespondsOK;
    [Test]
    procedure StubRequest_MatchingFormDataRegEx_RespondsOK;
    [Test]
    procedure StubRequest_MatchingJSONString_RespondsOK;
    [Test]
    procedure StubRequest_MatchingJSONInteger_RespondsOK;
    [Test]
    procedure StubRequest_MatchingJSONDecimal_RespondsOK;
    [Test]
    procedure StubRequest_MatchingJSONBoolean_RespondsOK;
    [Test]
    procedure StubRequest_MatchingJSONNestedValue_RespondsOK;
  end;

implementation

uses
  System.Classes,
  System.Net.URLClient,
  System.RegularExpressions,
  WebMock.ResponseStatus;

procedure TMatchingBodyContentTests.Setup;
begin
  Client := THTTPClient.Create;
  WebMock := TWebMock.Create;
end;

procedure TMatchingBodyContentTests.StubRequest_MatchingBodyContentRegEx_RespondsOK;
var
  LResponse: IHTTPResponse;
  LContent: TStream;
  LHeaders: TNetHeaders;
begin
  WebMock.StubRequest('*', '*')
    .WithBody(TRegEx.Create('Hello'))
    .ToRespond.WithStatus(OK);

  LHeaders := TNetHeaders.Create(
    TNetHeader.Create('content-type', 'text/plain')
  );
  LContent := TStringStream.Create('Hello world!');
  LResponse := Client.Post(WebMock.URLFor('/'), LContent, nil, LHeaders);

  Assert.AreEqual(200, LResponse.StatusCode);

  LContent.Free;
end;

procedure TMatchingBodyContentTests.StubRequest_MatchingBodyContentString_RespondsOK;
var
  LResponse: IHTTPResponse;
  LContent: TStream;
  LHeaders: TNetHeaders;
begin
  WebMock.StubRequest('*', '*')
    .WithBody('Hello')
    .ToRespond.WithStatus(OK);

  LHeaders := TNetHeaders.Create(
    TNetHeader.Create('content-type', 'text/plain')
  );
  LContent := TStringStream.Create('Hello');
  LResponse := Client.Post(WebMock.URLFor('/'), LContent, nil, LHeaders);

  Assert.AreEqual(200, LResponse.StatusCode);

  LContent.Free;
end;

procedure TMatchingBodyContentTests.StubRequest_MatchingFormDataExistence_RespondsOK;
var
  LResponse: IHTTPResponse;
  LForm: TStringList;
begin
  WebMock.StubRequest('*', '*')
    .WithFormData('Email', '*')
    .ToRespond.WithStatus(OK);

  LForm := TStringList.Create;
  LForm.Values['Email'] := 'user@example.com';
  LResponse := Client.Post(WebMock.URLFor('/'), LForm);

  Assert.AreEqual(200, LResponse.StatusCode);

  LForm.Free;
end;

procedure TMatchingBodyContentTests.StubRequest_MatchingFormDataRegEx_RespondsOK;
var
  LResponse: IHTTPResponse;
  LForm: TStringList;
begin
  WebMock.StubRequest('*', '*')
    .WithFormData('Email', TRegEx.Create('.*@example.com'))
    .ToRespond.WithStatus(OK);

  LForm := TStringList.Create;
  LForm.Values['Email'] := 'user@example.com';
  LResponse := Client.Post(WebMock.URLFor('/'), LForm);

  Assert.AreEqual(200, LResponse.StatusCode);

  LForm.Free;
end;

procedure TMatchingBodyContentTests.StubRequest_MatchingFormDataString_RespondsOK;
var
  LResponse: IHTTPResponse;
  LForm: TStringList;
begin
  WebMock.StubRequest('*', '*')
    .WithFormData('Email', 'user@example.com')
    .ToRespond.WithStatus(OK);

  LForm := TStringList.Create;
  LForm.Values['Email'] := 'user@example.com';
  LResponse := Client.Post(WebMock.URLFor('/'), LForm);

  Assert.AreEqual(200, LResponse.StatusCode);

  LForm.Free;
end;

procedure TMatchingBodyContentTests.StubRequest_MatchingJSONBoolean_RespondsOK;
var
  LResponse: IHTTPResponse;
  LContent: TStream;
begin
  WebMock.StubRequest('*', '*')
    .WithJSON('optIn', True)
    .ToRespond.WithStatus(OK);

  LContent := TStringStream.Create('{ "optIn": true }');
  LResponse := Client.Post(WebMock.URLFor('/'), LContent);

  Assert.AreEqual(200, LResponse.StatusCode);

  LContent.Free;
end;

procedure TMatchingBodyContentTests.StubRequest_MatchingJSONDecimal_RespondsOK;
var
  LResponse: IHTTPResponse;
  LContent: TStream;
begin
  WebMock.StubRequest('*', '*')
    .WithJSON('balance', 1.234)
    .ToRespond.WithStatus(OK);

  LContent := TStringStream.Create('{ "balance": 1.234 }');
  LResponse := Client.Post(WebMock.URLFor('/'), LContent);

  Assert.AreEqual(200, LResponse.StatusCode);

  LContent.Free;
end;

procedure TMatchingBodyContentTests.StubRequest_MatchingJSONInteger_RespondsOK;
var
  LResponse: IHTTPResponse;
  LContent: TStream;
begin
  WebMock.StubRequest('*', '*')
    .WithJSON('age', 25)
    .ToRespond.WithStatus(OK);

  LContent := TStringStream.Create('{ "age": 25 }');
  LResponse := Client.Post(WebMock.URLFor('/'), LContent);

  Assert.AreEqual(200, LResponse.StatusCode);

  LContent.Free;
end;

procedure TMatchingBodyContentTests.StubRequest_MatchingJSONNestedValue_RespondsOK;
var
  LResponse: IHTTPResponse;
  LContent: TStream;
begin
  WebMock.StubRequest('*', '*')
    .WithJSON('users[0].name', 'Chester Copperpot')
    .ToRespond.WithStatus(OK);

  LContent := TStringStream.Create(
    '{ "users": [ { "name": "Chester Copperpot" } ] }'
  );
  LResponse := Client.Post(WebMock.URLFor('/'), LContent);

  Assert.AreEqual(200, LResponse.StatusCode);

  LContent.Free;
end;

procedure TMatchingBodyContentTests.StubRequest_MatchingJSONString_RespondsOK;
var
  LResponse: IHTTPResponse;
  LContent: TStream;
begin
  WebMock.StubRequest('*', '*')
    .WithJSON('name', 'Chester Copperpot')
    .ToRespond.WithStatus(OK);

  LContent := TStringStream.Create('{ "name": "Chester Copperpot" }');
  LResponse := Client.Post(WebMock.URLFor('/'), LContent);

  Assert.AreEqual(200, LResponse.StatusCode);

  LContent.Free;
end;

procedure TMatchingBodyContentTests.TearDown;
begin
  WebMock.Free;
  Client.Free;
end;

initialization
  TDUnitX.RegisterTestFixture(TMatchingBodyContentTests);

end.

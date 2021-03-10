unit MatchingHeadersTests;

interface

uses
  DUnitX.TestFramework,
  System.Net.HttpClient,
  WebMock;

type
  [TestFixture]
  TMatchingHeadersTests = class
  private
    Client: THTTPClient;
    WebMock: TWebMock;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure StubRequest_MatchingHeaderString_RespondsOK;
    [Test]
    procedure StubRequest_MatchingHeaderExistence_RespondsOK;
    [Test]
    procedure StubRequest_MatchingHeaderRegEx_RespondsOK;
    [Test]
    procedure StubRequest_MatchingMultipleHeaders_RespondsOK;
    [Test]
    procedure StubRequest_MatchingMultipleHeadersWithStrings_RespondsOK;
  end;

implementation

uses
  System.Classes,
  System.Net.URLClient,
  System.RegularExpressions,
  WebMock.ResponseStatus;

procedure TMatchingHeadersTests.Setup;
begin
  Client := THTTPClient.Create;
  WebMock := TWebMock.Create;
end;

procedure TMatchingHeadersTests.StubRequest_MatchingHeaderExistence_RespondsOK;
var
  LResponse: IHTTPResponse;
  LContent: TStream;
  LHeaders: TNetHeaders;
begin
  WebMock.StubRequest('*', '*')
    .WithHeader('content-type', '*')
    .ToRespond.WithStatus(OK);

  LHeaders := TNetHeaders.Create(
    TNetHeader.Create('content-type', 'video/mp4')
  );
  LContent := TMemoryStream.Create;
  LResponse := Client.Post(WebMock.URLFor('/'), LContent, nil, LHeaders);

  Assert.AreEqual(200, LResponse.StatusCode);

  LContent.Free;
end;

procedure TMatchingHeadersTests.StubRequest_MatchingHeaderRegEx_RespondsOK;
var
  LResponse: IHTTPResponse;
  LContent: TStream;
  LHeaders: TNetHeaders;
begin
  WebMock.StubRequest('*', '*')
    .WithHeader('content-type', TRegEx.Create('video/.*'))
    .ToRespond.WithStatus(OK);

  LHeaders := TNetHeaders.Create(
    TNetHeader.Create('content-type', 'video/mp4')
  );
  LContent := TMemoryStream.Create;
  LResponse := Client.Post(WebMock.URLFor('/'), LContent, nil, LHeaders);

  Assert.AreEqual(200, LResponse.StatusCode);

  LContent.Free;
end;

procedure TMatchingHeadersTests.StubRequest_MatchingHeaderString_RespondsOK;
var
  LResponse: IHTTPResponse;
  LContent: TStream;
  LHeaders: TNetHeaders;
begin
  WebMock.StubRequest('*', '*')
    .WithHeader('content-type', 'video/mp4')
    .ToRespond.WithStatus(OK);

  LHeaders := TNetHeaders.Create(
    TNetHeader.Create('content-type', 'video/mp4')
  );
  LContent := TMemoryStream.Create;
  LResponse := Client.Post(WebMock.URLFor('/'), LContent, nil, LHeaders);

  Assert.AreEqual(200, LResponse.StatusCode);

  LContent.Free;
end;

procedure TMatchingHeadersTests.StubRequest_MatchingMultipleHeadersWithStrings_RespondsOK;
var
  LHeaderStrings: TStringList;
  LResponse: IHTTPResponse;
  LContent: TStream;
  LHeaders: TNetHeaders;
begin
  LHeaderStrings := TStringList.Create;
  LHeaderStrings.Values['accept'] := 'text/json';
  LHeaderStrings.Values['content-type'] := 'text/json';
  WebMock.StubRequest('*', '*')
    .WithHeaders(LHeaderStrings)
    .ToRespond.WithStatus(OK);

  LHeaders := TNetHeaders.Create(
    TNetHeader.Create('accept', 'text/json'),
    TNetHeader.Create('content-type', 'text/json')
  );
  LContent := TMemoryStream.Create;
  LResponse := Client.Post(WebMock.URLFor('/'), LContent, nil, LHeaders);

  Assert.AreEqual(200, LResponse.StatusCode);

  LContent.Free;
end;

procedure TMatchingHeadersTests.StubRequest_MatchingMultipleHeaders_RespondsOK;
var
  LResponse: IHTTPResponse;
  LContent: TStream;
  LHeaders: TNetHeaders;
begin
  WebMock.StubRequest('*', '*')
    .WithHeader('accept', 'text/json')
    .WithHeader('content-type', 'text/json')
    .ToRespond.WithStatus(OK);

  LHeaders := TNetHeaders.Create(
    TNetHeader.Create('accept', 'text/json'),
    TNetHeader.Create('content-type', 'text/json')
  );
  LContent := TMemoryStream.Create;
  LResponse := Client.Post(WebMock.URLFor('/'), LContent, nil, LHeaders);

  Assert.AreEqual(200, LResponse.StatusCode);

  LContent.Free;
end;

procedure TMatchingHeadersTests.TearDown;
begin
  WebMock.Free;
  Client.Free;
end;

initialization
  TDUnitX.RegisterTestFixture(TMatchingHeadersTests);

end.

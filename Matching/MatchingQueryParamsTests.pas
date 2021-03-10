unit MatchingQueryParamsTests;

interface

uses
  DUnitX.TestFramework,
  System.Net.HttpClient,
  WebMock;

type
  [TestFixture]
  TMatchingQueryParamsTests = class
  private
    Client: THTTPClient;
    WebMock: TWebMock;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure StubRequest_MatchingQueryParamString_RespondsOK;
    [Test]
    procedure StubRequest_MatchingQueryParamExistence_RespondsOK;
    [Test]
    procedure StubRequest_MatchingQueryParamByRegEx_RespondsOK;
  end;

implementation

uses
  System.RegularExpressions,
  WebMock.ResponseStatus;

{ TMatchingQueryParamsTests }

procedure TMatchingQueryParamsTests.Setup;
begin
  Client := THTTPClient.Create;
  WebMock := TWebMock.Create;
end;

procedure TMatchingQueryParamsTests.StubRequest_MatchingQueryParamByRegEx_RespondsOK;
var
  LResponse: IHTTPResponse;
begin
  WebMock.StubRequest('*', '*')
    .WithQueryParam('Action', TRegEx.Create('List.*'))
    .ToRespond.WithStatus(OK);

  LResponse := Client.Get(WebMock.URLFor('/endpoint?Action=ListWidgets'));

  Assert.AreEqual(200, LResponse.StatusCode);
end;

procedure TMatchingQueryParamsTests.StubRequest_MatchingQueryParamExistence_RespondsOK;
var
  LResponse: IHTTPResponse;
begin
  WebMock.StubRequest('*', '*')
    .WithQueryParam('Action', '*')
    .ToRespond.WithStatus(OK);

  LResponse := Client.Get(WebMock.URLFor('/endpoint?Action=DoSomething'));

  Assert.AreEqual(200, LResponse.StatusCode);
end;

procedure TMatchingQueryParamsTests.StubRequest_MatchingQueryParamString_RespondsOK;
var
  LResponse: IHTTPResponse;
begin
  WebMock.StubRequest('*', '*')
    .WithQueryParam('Action', 'DoSomething')
    .ToRespond.WithStatus(OK);

  LResponse := Client.Get(WebMock.URLFor('/endpoint?Action=DoSomething'));

  Assert.AreEqual(200, LResponse.StatusCode);
end;

procedure TMatchingQueryParamsTests.TearDown;
begin
  WebMock.Free;
  Client.Free;
end;

initialization
  TDUnitX.RegisterTestFixture(TMatchingQueryParamsTests);

end.

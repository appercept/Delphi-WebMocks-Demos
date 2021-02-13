unit ResponseStatusTests;

interface

uses
  DUnitX.TestFramework,
  System.Net.HttpClient,
  WebMock;

type
  [TestFixture]
  TResponseStatusTests = class
  private
    Client: THTTPClient;
    WebMock: TWebMock;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure ToRespond_GivenInteger_SetsResponseStatusCode;
    [Test]
    procedure ToRespond_GivenStatusSymbol_SetsResponseStatusCode;
    [Test]
    procedure WithStatus_GivenInteger_SetsResponseStatusCode;
    [Test]
    procedure WithStatus_GivenStatusSymbol_SetsResponseStatusCode;
    [Test]
    procedure WithStatus_GivenCustomStatus_SetsResponseStatusCodeAndText;
  end;

implementation

uses
  WebMock.ResponseStatus;

procedure TResponseStatusTests.Setup;
begin
  Client := THTTPClient.Create;
  WebMock := TWebMock.Create;
end;

procedure TResponseStatusTests.TearDown;
begin
  WebMock.Free;
  Client.Free;
end;

procedure TResponseStatusTests.WithStatus_GivenCustomStatus_SetsResponseStatusCodeAndText;
var
  LResponse: IHTTPResponse;
begin
  WebMock.StubRequest('GET', '/').ToRespond.WithStatus(321, 'Back In The Room');

  LResponse := Client.Get(WebMock.URLFor('/'));

  Assert.AreEqual(321, LResponse.StatusCode);
  Assert.AreEqual('Back In The Room', LResponse.StatusText);
end;

procedure TResponseStatusTests.WithStatus_GivenInteger_SetsResponseStatusCode;
var
  LResponse: IHTTPResponse;
begin
  WebMock.StubRequest('GET', '/').ToRespond.WithStatus(204);

  LResponse := Client.Get(WebMock.URLFor('/'));

  Assert.AreEqual(204, LResponse.StatusCode);
end;

procedure TResponseStatusTests.WithStatus_GivenStatusSymbol_SetsResponseStatusCode;
var
  LResponse: IHTTPResponse;
begin
  WebMock.StubRequest('GET', '/').ToRespond.WithStatus(NoContent);

  LResponse := Client.Get(WebMock.URLFor('/'));

  Assert.AreEqual(204, LResponse.StatusCode);
end;

procedure TResponseStatusTests.ToRespond_GivenInteger_SetsResponseStatusCode;
var
  LResponse: IHTTPResponse;
begin
  WebMock.StubRequest('GET', '/').ToRespond(204);

  LResponse := Client.Get(WebMock.URLFor('/'));

  Assert.AreEqual(204, LResponse.StatusCode);
end;

procedure TResponseStatusTests.ToRespond_GivenStatusSymbol_SetsResponseStatusCode;
var
  LResponse: IHTTPResponse;
begin
  WebMock.StubRequest('GET', '/').ToRespond(NoContent);

  LResponse := Client.Get(WebMock.URLFor('/'));

  Assert.AreEqual(204, LResponse.StatusCode);
end;

initialization
  TDUnitX.RegisterTestFixture(TResponseStatusTests);

end.

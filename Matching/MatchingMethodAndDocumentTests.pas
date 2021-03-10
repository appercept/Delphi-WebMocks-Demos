unit MatchingMethodAndDocumentTests;

interface

uses
  DUnitX.TestFramework,
  System.Net.HttpClient,
  WebMock;

type
  [TestFixture]
  TMatchingMethodAndDocumentTests = class
  private
    Client: THTTPClient;
    WebMock: TWebMock;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure StubRequest_MatchingRESTCreate_ReturnsCreated;
    [Test]
    procedure StubRequest_MatchingRESTIndex_ReturnsOK;
    [Test]
    procedure StubRequest_MatchingRESTShow_ReturnsOK;
    [Test]
    procedure StubRequest_MatchingRESTUpdatePATCH_ReturnsOK;
    [Test]
    procedure StubRequest_MatchingRESTUpdatePUT_ReturnsOK;
    [Test]
    procedure StubRequest_MatchingRESTDelete_ReturnsNoContent;
  end;

implementation

uses
  System.Classes,
  WebMock.ResponseStatus;

procedure TMatchingMethodAndDocumentTests.Setup;
begin
  Client := THTTPClient.Create;
  WebMock := TWebMock.Create;
end;

procedure TMatchingMethodAndDocumentTests.StubRequest_MatchingRESTCreate_ReturnsCreated;
var
  LResponse: IHTTPResponse;
  LRequestContent: TStream;
begin
  LRequestContent := TMemoryStream.Create;
  WebMock.StubRequest('POST', '/widgets').ToRespond.WithStatus(Created);

  LResponse := Client.Post(WebMock.URLFor('/widgets'), LRequestContent);

  Assert.AreEqual(201, LResponse.StatusCode);

  LRequestContent.Free;
end;

procedure TMatchingMethodAndDocumentTests.StubRequest_MatchingRESTDelete_ReturnsNoContent;
var
  LResponse: IHTTPResponse;
begin
  WebMock.StubRequest('DELETE', '/widgets/1').ToRespond.WithStatus(NoContent);

  LResponse := Client.Delete(WebMock.URLFor('/widgets/1'));

  Assert.AreEqual(204, LResponse.StatusCode);
end;

procedure TMatchingMethodAndDocumentTests.StubRequest_MatchingRESTIndex_ReturnsOK;
var
  LResponse: IHTTPResponse;
begin
  WebMock.StubRequest('GET', '/widgets').ToRespond.WithStatus(OK);

  LResponse := Client.Get(WebMock.URLFor('/widgets'));

  Assert.AreEqual(200, LResponse.StatusCode);
end;

procedure TMatchingMethodAndDocumentTests.StubRequest_MatchingRESTShow_ReturnsOK;
var
  LResponse: IHTTPResponse;
begin
  WebMock.StubRequest('GET', '/widgets/1').ToRespond.WithStatus(OK);

  LResponse := Client.Get(WebMock.URLFor('/widgets/1'));

  Assert.AreEqual(200, LResponse.StatusCode);
end;

procedure TMatchingMethodAndDocumentTests.StubRequest_MatchingRESTUpdatePATCH_ReturnsOK;
var
  LResponse: IHTTPResponse;
begin
  WebMock.StubRequest('PATCH', '/widgets/1').ToRespond.WithStatus(OK);

  LResponse := Client.Patch(WebMock.URLFor('/widgets/1'));

  Assert.AreEqual(200, LResponse.StatusCode);
end;

procedure TMatchingMethodAndDocumentTests.StubRequest_MatchingRESTUpdatePUT_ReturnsOK;
var
  LResponse: IHTTPResponse;
begin
  WebMock.StubRequest('PATCH', '/widgets/1').ToRespond.WithStatus(OK);

  LResponse := Client.Patch(WebMock.URLFor('/widgets/1'));

  Assert.AreEqual(200, LResponse.StatusCode);
end;

procedure TMatchingMethodAndDocumentTests.TearDown;
begin
  WebMock.Free;
  Client.Free;
end;

initialization
  TDUnitX.RegisterTestFixture(TMatchingMethodAndDocumentTests);

end.
